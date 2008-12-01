Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYLABOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYLABOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 20:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYLABO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 20:14:27 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:5378 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYLABO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 20:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iavWMi+/QpNVBPEywykMpve/krs4aKElRb47zAeBDejiXOzhFHgtydZhOGZrGAHzoP
         zr8HsodqXQZCCEqC1qL+OjRwD47bNLJ6qhPAmHcpcLSGQ0dyZkH+TBWP1aA6qTLo+zMR
         QfE+H2bEP8VqF0AYVKpdWGpLhSGu/tdFkFglM=
Message-ID: <f17812d70811301714k78f09beby9ffc9ef60d5ef1a5@mail.gmail.com>
Date: Mon, 1 Dec 2008 09:14:25 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] drivers/video/backlight: rename da903x to da903x_bl
Cc: "Mike Rapoport" <mike@compulab.co.il>, "Eric Miao" <ymiao3@marvell.com>,
       rpurdie@rpsys.net, linux-kernel@vger.kernel.org
In-Reply-To: <20081129130329.GA13867@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227606164-12659-1-git-send-email-mike@compulab.co.il>
	 <E913911567467945BBEB9277E27868B00153DC31@msiexch01.marvell.com>
	 <492BCD01.7080508@compulab.co.il>
	 <f17812d70811260012n57e89eb9q1101fa1e13813a49@mail.gmail.com>
	 <20081129130329.GA13867@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 9:03 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Nov 26, 2008 at 04:12:07PM +0800, Eric Miao wrote:
>> Sam,
>>
>> Do you have any suggestion to this?
>>
> [snip two modules with same name does not work...]
>
> kbuild today create one file for each module in the
> directory: .tmp_versions/
>
> So in this case the module that is build lst is the winner.
>
> I do not see any easy way to avoid this.
> What we could do:
> 1) find another way to record what modules we have
> 2) embed path in filename
>
> I did not try to actually implement any of the above
> as the gain seems minimal compared to the additional complexity.
>
>        Sam
>

OK, fair enough to add my Ack here to Mike's original patch:

Acked-by: Eric Miao <eric.miao@marvell.com>
