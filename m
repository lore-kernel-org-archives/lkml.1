Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYIIPe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYIIPe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYIIPeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:34:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:37951 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYIIPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EDwpBx4nElgCUAFosgrxSjvt9xC66AwXPGljKq+wxYNESb4SEWxsCCFAZAJKG+Frif
         kQ2Ijh8LtQ1gty39NNH7zgOOcAP2YmioSb8391WEPVrf4yWaIWm2r2sM1k/jfOCnrDSa
         W0GSMHf7iik9WyhbiaXbRG/2aTS3WwK+2/oTQ=
Message-ID: <9e4733910809090834y1ec1662bo12c382fd9788115@mail.gmail.com>
Date: Tue, 9 Sep 2008 11:34:15 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 0/18] linux infrared remote control drivers
Cc: "Jarod Wilson" <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       "Jarod Wilson" <jarod@redhat.com>, "Janne Grunau" <j@jannau.net>,
       "Christoph Bartelmus" <lirc@bartelmus.de>,
       "Eric Sandeen" <esandeen@redhat.com>,
       "Mario Limonciello" <superm1@ubuntu.com>
In-Reply-To: <20080909124608.GA27837@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	 <20080909124608.GA27837@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/08, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Sep 09, 2008 at 12:05:45AM -0400, Jarod Wilson wrote:
>
> > The following patch series adds 17 new drivers for assorted infrared and/or RF
>  > remote control receivers and/or transmitters. These drivers have long lived
>  > out-of-tree at http://www.lirc.org/, packaged as 3rd-party modules by many
>  > distributions, and more recently, patched into the kernels of at least Fedora
>  > and Ubuntu. The primary maintainer of lirc, Christoph Bartelmus simply hasn't
>  > had the time to send these bits upstream, and a few months back, gave me the
>  > go-ahead to take on the task.
>
>
> Any reason this is a separate subsystem instead of just a bunch new
>  drivers for the input subsystem?

I've been asking this one too. Can someone familiar with the guts of
input give an assessment of integrating LIRC in with the rest of
input? Don't we want these events handled via evdev so that ordering
between IR, mouse, keyboard will be maintained?

-- 
Jon Smirl
jonsmirl@gmail.com
