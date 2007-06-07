Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbXFGNp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbXFGNp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbXFGNpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:45:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:56407 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbXFGNpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Gx1aMSxT6YyS+GXubG8hK0AH6GXpsEgR5tOF/8lxXl1sfv7QR7LsEj+d7vJBNWSIpgL1TOlTNsZ7p9VOXPnexcpwHKK5hqMZndyWMzCjX+JFiipp9I4ZAj4Q9Yqif6sGMiAm4t4SrjTvZ6sfPr8EgYNjenTompjakNVX3/Qc6co=
Message-ID: <e9e943910706070645p29519138i7e76b3a9649d387@mail.gmail.com>
Date: Thu, 7 Jun 2007 14:45:51 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "David Greaves" <david@dgreaves.com>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
Cc: "Tejun Heo" <htejun@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, "Neil Brown" <neilb@suse.de>
In-Reply-To: <4667DE2D.6050903@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46608E3F.4060201@dgreaves.com> <46609FAD.7010203@dgreaves.com>
	 <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com>
	 <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org>
	 <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com>
	 <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com>
	 <4667DE2D.6050903@dgreaves.com>
X-Google-Sender-Auth: 749024c516b999cd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/07, David Greaves <david@dgreaves.com> wrote:
> > How hard does the machine freeze?  Can you use sysrq?  If so, please
> > dump sysrq-t.
> I suspect there is a problem writing to the consoles...
>
> I recompiled (rc4+patch) with sysrq support, suspended, resumed and tried
> sysrq-t but got no output.
>
> I *can* change VTs and see the various login prompts, bitmap messages and the
> console messages. Caps/Num lock lights work.
>
> Fearing incompetence I tried sysrq-s sysrq-u sysrq-b and got a reboot so sysrq
> is OK.

Try sysrq-9 before the sysrq-t. Probably the messages are not being
printed to console with your default output level.

Cheers,
Duane Griffin.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
