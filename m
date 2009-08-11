Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZHKMEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZHKMEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZHKMEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:04:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:61881 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZHKMEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EQUAT1DR7u4lspP38onq4FdP5TAJbjewhFGcXnP3CW4NNQZ4QCTL5u0HeDtMgKKt2Y
         5hEdGMrf6GnmcdieQSr/+Qp6HIlEYTCAUGgN1JFzDEEQsw26wKcoewGxBWooNIQk0eDI
         ohKNUaH2Y6vNEJwT9P/L8XrtkUJpBEHTmQiRE=
MIME-Version: 1.0
In-Reply-To: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
Date: Tue, 11 Aug 2009 12:35:13 +0200
Message-ID: <e2e108260908110335tc500412mc6354359d85ae9b6@mail.gmail.com>
Subject: Re: [PATCH 0/3]: blk-iopoll, a polled completion API for block 
	devices
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Eric.Moore@lsi.com, jeff@garzik.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 9:58 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> Anyway, YMMV, I would appreciate some test results (and as usual, that
> even includes just saying that it boots and functions for you). If
> people feel adventurous, patches for other controllers will be happily
> queued up for testing. I may even be convinced to implement support
> for your controller of choice, if you have some fast storage hooked up
> and would like to experiment. Generally, adding support to a driver is
> not very hard and the two conversions included were also meant to serve
> as an inspiration.

Sounds very interesting. Have you already considered patching the SRP
initiator ? During the SRP performance tests I ran CPU usage on the
initiator was more than 95% and on the target less than 10%.

Bart.
