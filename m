Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYJAOCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYJAOCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYJAOCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:02:05 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:46391 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYJAOCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=NOU8nXwYVf6afSBJpX/AQ5tdng9RuagW1yvEICiSLZQUrKPesZngeZms/m2WN2OL8z
         75/iLkR2J4OBgyvZRQLXh2ZXE8C/o6OSQxJzwhJoBTEYqT4HtFLr90BbyTQAZgE84eyi
         iMIXhKFtSCVfDX7ntGiHOTUC9rQUEa5l7d7n4=
Message-ID: <9ea470500810010702t5ff5e50di3c0182d0641c3dd5@mail.gmail.com>
Date: Wed, 1 Oct 2008 16:02:02 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: CD tray closes spontaneously after opening it
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Tony Vroon" <tony@vroon.org>,
       linux-kernel@vger.kernel.org, "Tejun Heo" <tj@kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <200810011553.05318.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809301247.05367.elendil@planet.nl>
	 <200809302150.38872.elendil@planet.nl>
	 <ac3eb2510809301302l7d966896tfb0e3d230598974@mail.gmail.com>
	 <200810011553.05318.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 1, 2008 at 3:53 PM, Frans Pop <elendil@planet.nl> wrote:
> On Tuesday 30 September 2008, Kay Sievers wrote:
>> >> Does this also happen when you set:
>> >>   /proc/sys/dev/cdrom/autoclose
>> >> to 0?
>> >
>> > I'll set that on boot using /etc/sysctl.conf and will report if I can
>> > still reproduce with that setting. I've checked that the "normal"
>> > value is 1.
>>
>> That will prevent the closing, when something tries to open the device
>> in blocking mode. If that solves the issue, you should start looking
>> which process tries to access your drive.
>
> Right. It happens with autoclose=0 too.
>
> Any suggestions for the next step? Maybe add some instrumentation in the
> cdrom or ide-cd drivers?

I have a debugging infrastructure ready in ide-cd which is in Bart's tree, you
could apply it ontop of current git, enable it and send dmesg so that we could
see exactly what is going on:

http://www.kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/

-- 
Regards/Gruss,
Boris
