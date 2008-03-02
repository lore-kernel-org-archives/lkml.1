Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbYCBUTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbYCBUTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYCBUTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:19:12 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:44837 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbYCBUTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:19:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=i8GZ+5rLuymz0tCALjqwtwKbcQnsW2EVxXbxFp2WhYX2mxUezhGRlEijpqznOaTTGb5zOwWrxii0O5OAVPdamxGpshOiJrhSE3ylEo0QoqyiTSWysBAsQfWOCxZZklcNycIGZ/XzjxtxxM0QPF2sPzmmPJzsMLYC8HRo5+mS/4k=
Message-ID: <8b67d60803021219k23ca6c6bt2ce2fb2c61cda42e@mail.gmail.com>
Date: Sun, 2 Mar 2008 20:19:09 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, dwmw2@infradead.org
Subject: MTD types
Cc: linux-sh <linux-sh@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A long time ago I took some work Paul Mundt did and used to build a
working driver for the Sega Dreamcast Visual Memory Unit flash memory.

I am now trying to revive that for 2.6 kernels.

In the past the flash was simply described as MTD_OTHER - but I see from:

http://lkml.org/lkml/2006/4/13/151

that type was axed as it was thought unused (not unreasonable - my &
Paul's driver resided in the Dreamcast Linux CVS, not anywhere near
mainline).

I am loathe to just post a patch adding it back, so does it make any
difference if I use another type (I really have no idea of what the
physical type used in the Dreamcast is, though possibly someone here
might?)

Adrian
