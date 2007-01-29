Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbXA2VSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbXA2VSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbXA2VSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:18:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:63328 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbXA2VSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:18:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eJ0l2mlKZ8oPgoZhuQcynnRqhMssxjPCADW5t+eCA0NC4SGy7bGxIjROFFGE1q9qKjyAMBPYVixDMrL2/gaTE09wevSxA8AxyVz4q/no9jSKrYFhyjvhAWQxfoavovMa4PgnPbboJ25zUJGgfUFYq3UZiWJWWNPB/1H9NxvARbU=
Message-ID: <8d158e1f0701291318w6de001d4xe5cb86f7c0ad205f@mail.gmail.com>
Date: Mon, 29 Jan 2007 22:18:44 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Boot problems with pata_via driver
In-Reply-To: <8d158e1f0701291301q18040b76t162bf09cca16660b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0701280347l1d778528la0d69647726485d6@mail.gmail.com>
	 <20070128231147.GA6017@stusta.de>
	 <8d158e1f0701282330o3591a226lb664644ffdb025f0@mail.gmail.com>
	 <8d158e1f0701282332m3e22a649s621abc258c6103d5@mail.gmail.com>
	 <8d158e1f0701291253u38607480m597d32815143c5e6@mail.gmail.com>
	 <8d158e1f0701291301q18040b76t162bf09cca16660b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/07, Patrick Ale <patrick.ale@gmail.com> wrote:

A lot of crap. And i am a fruitcake, nutter, headcase.

*sigh* sorry for wasting your time, I found my problem.
Since I thought libata worked like my old ata drivers and 2.6.19 was
booting well, I reconfigured my kernel source and changed
CONFIG_BLK_DEV=y to CONFIG_BLK_DEV=m, since I genuinely thought I
wouldnt need additional disk drivers since I never needed them for
IDE. I compiled the kernel and all but never copied over the bzImage
over to /boot/

Now, I grabbed the config from 2.6.19 , copied it to 2.6.20, ran a
make oldconfig && make && make_modules and copied the bzImage to
/boot/. Of course, the 2.6.20 image I try to boot DOES contain the
CONFIG_BLK_DEV=m , so it wont find any disks, since the module is not
active (I dont use ramdisks).

I reconfigured 2.6.20 with CONFIG_BLK_DEV=y , and its working now.
idiot I am, what else can I say.

Again, sorry for wasting your time.
