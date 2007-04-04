Return-Path: <linux-kernel-owner+w=401wt.eu-S2992829AbXDDKmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992829AbXDDKmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992839AbXDDKmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:42:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:1294 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992829AbXDDKmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=peyjn1Y2AIZx8YYvpoMhOQI3g/+SwK2hvEj/NJVGjSeERLGm/qxrE9S6mQ/7c15ONNsi5fxVrKWdS2/ckUV4fl/5/2F6ZIQ6jgOxCjbQAF+7o5S0VvtkG1gFJIepaoUirR1mbbJNvm53VWxHZuSGjYEGSvV93fZOVCNQAjn6zE4=
Message-ID: <88df6dda0704040342q3f8988a3idac7d88e51b9b181@mail.gmail.com>
Date: Wed, 4 Apr 2007 16:12:11 +0530
From: "Ameya Mitragotri" <ameya.mitragotri@gmail.com>
To: "Phillip Susi" <psusi@cfl.rr.com>
Subject: Re: fadvise+sync_file_range Vs O_DIRECT
Cc: linux-kernel@vger.kernel.org, suparna@in.ibm.com, pbadari@gmail.com
In-Reply-To: <4612A8C5.1080103@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <88df6dda0704030351u44fab6bcj20f9b48d24de861a@mail.gmail.com>
	 <4612A8C5.1080103@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/07, Phillip Susi <psusi@cfl.rr.com> wrote:
> Ameya Mitragotri wrote:
> > Hello,
> > I am doing some benchmarking on writes to the hdd from a simple
> > application (attached).
> > Im benchmarking the writes using the following
> > - write with O_DIRECT
> > - write with fadvise + O_SYNC
> > - write with fadvise + sync_file_range
>
> Did you use overlapped aio with O_DIRECT or just send down one request
> at a time?

The app sends the requests one at a time

Thanks
Ameya
