Return-Path: <linux-kernel-owner+w=401wt.eu-S965470AbXCASNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965470AbXCASNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 13:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965473AbXCASNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 13:13:38 -0500
Received: from ik-out-1112.google.com ([66.249.90.180]:57759 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965470AbXCASNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 13:13:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=byAY6i+BLsKQpGNyN89e7ueyDIPnpR+pj83kT/1Bo4OcHH2fI0mK1vjIs2fHaTFQVIGS3lWYkmrUkvVGq08U/u4fhSxxxxLTjxb0wFOW+JFO1+KQXcwYq3rLiNTBGyhD94eebpEXR5E8T1zcFv0BV6HvcDZnHpuhulGKqxRMrts=
Message-ID: <75b66ecd0703011013h704319c4h9f5ad7b572c53b28@mail.gmail.com>
Date: Thu, 1 Mar 2007 13:13:32 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "WHITE, JOE (ASI-AIT)" <jw2365@att.com>
Subject: Re: 3c905B - Transmit error, Tx status register 82
Cc: andrewm@uow.edu.au, netdev@oss.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <0D69EE79F863484FB73D20A95656730D02F9CBA1@ILNORT1MSGUSR18.ITServices.sbc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0D69EE79F863484FB73D20A95656730D02F9CBA1@ILNORT1MSGUSR18.ITServices.sbc.com>
X-Google-Sender-Auth: 741bf2f7fcce95a4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, WHITE, JOE (ASI-AIT) <jw2365@att.com> wrote:
> Mar  1 09:44:04 thor kernel: Probably a duplex mismatch.  See
> Documentation/networking/vortex.txt

Um... did you check Documentation/networking/vortex.txt?

261	Transmit error, Tx status register 82
262	-------------------------------------
263	
264	This is a common error which is almost always caused by another host on
265	the same network being in full-duplex mode, while this host is in
266	half-duplex mode.  You need to find that other host and make it run in
267	half-duplex mode or fix this host to run in full-duplex mode.
268	
269	As a last resort, you can force the 3c59x driver into full-duplex mode
270	with
271	
272		options 3c59x full_duplex=1
273	
274	but this has to be viewed as a workaround for broken network gear and
275	should only really be used for equipment which cannot autonegotiate.
276	

Lee
