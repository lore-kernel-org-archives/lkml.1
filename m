Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXDRUsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXDRUsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXDRUsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:48:55 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:57999 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753154AbXDRUsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:48:53 -0400
Date: Wed, 18 Apr 2007 13:15:44 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: James Morris <jmorris@namei.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <Line.LNX.4.64.0704180935100.25495@d.namei>
Message-ID: <Pine.LNX.4.63.0704181311390.2806@qynat.qvtvafvgr.pbz>
References: <20070417181016.GA10903@one.firstfloor.org><657751.18080.qm@web3
 6614.mail.mud.yahoo.com>  <20070417211653.GB11944@one.firstfloor.org><20070417225815.000b0fdb@the-vil
 lage.bc.nu> <Line.LNX.4.64.0704180935100.25495@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, James Morris wrote:

> On Tue, 17 Apr 2007, Alan Cox wrote:
>
>> I'm not sure if AppArmor can be made good security for the general case,
>> but it is a model that works in the limited http environment
>> (eg .htaccess) and is something people can play with and hack on and may
>> be possible to configure to be very secure.
>
> Perhaps -- until your httpd is compromised via a buffer overflow or
> simply misbehaves due to a software or configuration flaw, then the
> assumptions being made about its use of pathnames and their security
> properties are out the window.

since AA defines a whitelist of files that httpd is allowed to access, a 
comprimised one may be able to mess up it's files, but it's still not going to 
be able to touch other files on the system.

> Without security labeling of the objects being accessed, you can't protect
> against software flaws, which has been a pretty fundamental and widely
> understood requirement in general computing for at least a decade.

this is not true. you don't need to label all object and chunks of memory, you 
just need to have a way to list (and enforce) the objects and memory that the 
program is allowed to use. labeling them is one way of doing this, but not the 
only way.

David Lang
