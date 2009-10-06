Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZJFCCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZJFCCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 22:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZJFCCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 22:02:16 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:37312 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbZJFCCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 22:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dBWF6/2q3SKkOjLoJ6cmD7EoR2GJMVJAe3yFxgsC91EN341Nv5fYnjrcSCvVjgZh/x
         kqM4fsd6lfpl2WPnfvkmk7s9GVEV2cSHQazV8MY+1nsGd/xN5ZFngCv5MzZ/f1FnPlyr
         rhlzoK+CZRI+Pn+zGit1/6Jcfg1dEdRTKRSzg=
Message-ID: <4ACAA4D8.1080501@gmail.com>
Date: Mon, 05 Oct 2009 20:00:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org
Subject: Re: complete IO hang since a few kernel revision
References: <20091005011626.GH4335@gamma.logic.tuwien.ac.at> <4AC9607D.6050900@datenparkplatz.de> <20091005083308.GB5612@gandalf.dynalias.org>
In-Reply-To: <20091005083308.GB5612@gandalf.dynalias.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2009 02:33 AM, Norbert Preining wrote:
> On Mon, 05 Oct 2009, Ulrich Lukas wrote:
>> A number of patches went into 2.6.32-rc3 which was released today.
>
> Ok, with 2.6.32-rc3 running now.
>
>> Can you test if your problems are solved with this latest version?
>
> Example:
> dpkg-source -x of a big debian source package
> which is more or less untarring a big .tar and then applying a diff
> which is much smaller (tar.gz: 482M, diff.gz: 412k)
>
> The dpkg-source has finished, I am back at the prompt.
>
> At the same time a simple
> 	$<ENTER>
> in a different xterm did not produce *any* thing, no output, for about
> 30 seconds. I mean 30 seconds waiting for an empty command is a bit
> strange I would say.
>
> I don't know to which this is related, but it seems quite buggy.
>
> Best wishes
>
> Norbert

Are you getting any errors showing up in dmesg?
