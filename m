Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYIPPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYIPPaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYIPPaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:30:20 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36997 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbYIPPaR (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZL6v9nDDK4wYT/F9Izq2qgHA3py9toi0b4Svjv7PwI9VGEoeehzt3OayWs6DwUNy3g
         30MpkC7Iweiw45EwtqHD1BwaSpBQP/+HWHiv4YBtGcubUe57quX6x3XPmvp15almRb65
         eNVgpLhY0lumWQ2AWBmtLtOhyG7+tjoMLbYgI=
Message-ID: <6934efce0809160830v461a115ch305aeaadaf5d9883@mail.gmail.com>
Date: Tue, 16 Sep 2008 08:30:16 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Ricard Wanderlof" <ricard.wanderlof@axis.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: "Jamie Lokier" <jamie@shareable.org>,
       "cotte@de.ibm.com" <cotte@de.ibm.com>,
       "Greg Ungerer" <gerg@snapgear.com>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>,
       "Linux-kernel@vger.kernel.org" <Linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "tim.bird@am.sony.com" <tim.bird@am.sony.com>
In-Reply-To: <Pine.LNX.4.64.0809160856190.5966@lnxricardw.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080915163421.GA13631@shareable.org>
	 <Pine.LNX.4.64.0809160856190.5966@lnxricardw.se.axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NAND is significantly faster when writing than NOR, read speed is of the
> same magnitude, possibly slower in many cases.

Right.

Specifically, read bandwidth is on the same order of magnitude.
However the read latency of NAND is a couple orders of magnitude
higher (100ns vs 20,000ns) so it depends on what you are doing.
