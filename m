Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZDTSHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZDTSHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZDTSHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:07:31 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:37132 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbZDTSHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:07:31 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 14:07:30 EDT
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH]: uvcvideo: fill reserved fields with zero of VIDIOC_QUERYMENU
Date: Mon, 20 Apr 2009 19:59:52 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28; KDE/4.2.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <49E9EAC8.9000706@freemail.hu>
In-Reply-To: <49E9EAC8.9000706@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904201959.52885.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 18 April 2009 16:59:20 Németh Márton wrote:
> When querying menu items with VIDIOC_QUERYMENU the reserved field
> is not set to zero as required by V4L2 API revision 0.24 [1].
> Add this fill.
>
> The patch was tested with v4l-test 0.11 [2] with CNF7129 webcam found
> on EeePC 901.
>
> References:
> [1] V4L2 API specification, revision 0.24
>     http://v4l2spec.bytesex.org/spec/r13317.htm#V4L2-QUERYMENU
>
> [2] v4l-test: Test environment for Video For Linux Two API
>     http://v4l-test.sourceforge.net/

Applied with a small modification (use u32 instead of __u32).

Thanks.

Best regards,

Laurent Pinchart

