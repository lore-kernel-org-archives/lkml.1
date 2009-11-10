Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbZKJSvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbZKJSvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757603AbZKJSvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:51:51 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:51609 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbZKJSvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:51:50 -0500
Message-id: <4AF9B636.2010909@verizon.net>
Date: Tue, 10 Nov 2009 10:51:34 -0800
From: John Johansen <jrjohansen@verizon.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 07/12] AppArmor: userspace interfaces
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
 <1257869585-7092-8-git-send-email-john.johansen@canonical.com>
 <84144f020911100829k515c7f73w84df942162a49a30@mail.gmail.com>
In-reply-to: <84144f020911100829k515c7f73w84df942162a49a30@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi John,
> 
> On Tue, Nov 10, 2009 at 6:13 PM, John Johansen
> <john.johansen@canonical.com> wrote:
>> The current apparmorfs interface is compatible with previous versions
>> of AppArmor.  The plans are to deprecate it (hence the config option
>> APPARMOR_COMPAT_24) and replace it with a more sysfs style single
>> entry per file interface.
> 
> We don't usually merge compatibility code to handle ABIs that were
> developed out-of-tree. Why should we treat AppArmor differently?
> 
Not necessarily saying you should.  We would certainly like to support the
current interface as it will be a pain for our users if newer kernels break
abi so the user space tools don't work.  And there is also that the compat
interface  is the only interface currently supported.  The goal was to
declare our intent to deprecate the interface and move to a new
interface interface in time.

cheers
john
