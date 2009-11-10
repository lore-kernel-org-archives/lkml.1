Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZKJSVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZKJSVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZKJSVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:21:32 -0500
Received: from mail.vyatta.com ([76.74.103.46]:52394 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbZKJSVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:21:32 -0500
Date: Tue, 10 Nov 2009 10:21:16 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       John Johansen <john.johansen@canonical.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 07/12] AppArmor: userspace interfaces
Message-ID: <20091110102116.2bc5bc4f@nehalam>
In-Reply-To: <87pr7qjpn8.fsf@basil.nowhere.org>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
	<1257869585-7092-8-git-send-email-john.johansen@canonical.com>
	<84144f020911100829k515c7f73w84df942162a49a30@mail.gmail.com>
	<87pr7qjpn8.fsf@basil.nowhere.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 17:44:27 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Pekka Enberg <penberg@cs.helsinki.fi> writes:
> 
> > On Tue, Nov 10, 2009 at 6:13 PM, John Johansen
> > <john.johansen@canonical.com> wrote:
> >> The current apparmorfs interface is compatible with previous versions
> >> of AppArmor.  The plans are to deprecate it (hence the config option
> >> APPARMOR_COMPAT_24) and replace it with a more sysfs style single
> >> entry per file interface.
> >
> > We don't usually merge compatibility code to handle ABIs that were
> > developed out-of-tree. Why should we treat AppArmor differently?
> 
> I would say that always depends on the deployed base of the old ABI.
> If there's a lot of users who would get broken I think there's a
> good case for merging compat code (I don't know if that is or
> isn't the case here). 
> 
> A widely used distribution release with the old user land would
> probably count.
> 

Then the distribution can maintain a patch to add the necessary translation

It is not the upstream kernel's job to maintain compatibility with older
out of tree code.
