Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbYJVTcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbYJVTcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYJVTbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:31:55 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:36157 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbYJVTby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JNAtu6C7hWBWOooo/ravfN2/8wJQ5/afwqo3hazYAdV+GIMMLpZ30AjlEMF9qHP7e4
         cPoa9GwJ+tO5luqrtsv0QTFPEVwvN+ti8PrfTPad+E7dg4AzGZhEOx3V6QbqarxxJTwL
         oS9OKbAoHGLawTyevaZKObg4JA57rSsACTKqY=
Message-ID: <b637ec0b0810221231w5a329e2cu84c8789e77a4eb59@mail.gmail.com>
Date: Wed, 22 Oct 2008 21:31:51 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: Possible bug in SCSI Kconfig
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20081022192650.GI26094@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
	 <1224702340.6851.20.camel@localhost.localdomain>
	 <b637ec0b0810221225q589ed071i75f559d6fa76d96b@mail.gmail.com>
	 <20081022192650.GI26094@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Oct 22, 2008 at 9:26 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Oct 22, 2008 at 09:25:46PM +0200, Fabio Comolli wrote:
>> I don't use initrd at all. I just noticed the existence of this module
>> while trying to have a non modular kernel. This failed because of
>> ipw2200 and after having enabled modules again I just found this
>> scsi_wait_scan.ko.
>
> If you turn off CONFIG_MODULES, the module goes away.

Unfortunately this is not an option because of ipw2200. I don't use
initrd and if I turn off CONFIG_MODULES the kernel hangs forever
requesting the firmware.

>
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
>

Regards,
Fabio
