Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZKJQo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZKJQo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbZKJQo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:44:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52986 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888AbZKJQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:44:26 -0500
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 07/12] AppArmor: userspace interfaces
From: Andi Kleen <andi@firstfloor.org>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
	<1257869585-7092-8-git-send-email-john.johansen@canonical.com>
	<84144f020911100829k515c7f73w84df942162a49a30@mail.gmail.com>
Date: Tue, 10 Nov 2009 17:44:27 +0100
In-Reply-To: <84144f020911100829k515c7f73w84df942162a49a30@mail.gmail.com> (Pekka Enberg's message of "Tue, 10 Nov 2009 18:29:52 +0200")
Message-ID: <87pr7qjpn8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@cs.helsinki.fi> writes:

> On Tue, Nov 10, 2009 at 6:13 PM, John Johansen
> <john.johansen@canonical.com> wrote:
>> The current apparmorfs interface is compatible with previous versions
>> of AppArmor.  The plans are to deprecate it (hence the config option
>> APPARMOR_COMPAT_24) and replace it with a more sysfs style single
>> entry per file interface.
>
> We don't usually merge compatibility code to handle ABIs that were
> developed out-of-tree. Why should we treat AppArmor differently?

I would say that always depends on the deployed base of the old ABI.
If there's a lot of users who would get broken I think there's a
good case for merging compat code (I don't know if that is or
isn't the case here). 

A widely used distribution release with the old user land would
probably count.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
