Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbXIRXGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbXIRXGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXIRXGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:06:23 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:8656 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbXIRXGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pbb6T9lmFvsbwVGeRBr6rdYHuj63T8ghL8vxJXHnr4biC5/TqvdBGvNTAXJ1WdTXb6iid64v/FEgsUjSjY/w207X7c8/4JRn9tLkmKZFnfpqFK1K8W2ugcPu1eH7VVm4XYvqQzud4QFGsyc3axzFuIa0ZD2FKGvx1D59wPk9zVs=
Message-ID: <70513aa50709181606n3cb5f5d2k5ab4e8f8b7c145ac@mail.gmail.com>
Date: Tue, 18 Sep 2007 16:06:21 -0700
From: Shentino <shentino@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG? Suspend during active sound playback kills sound
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Run any program that opens the ALSA sound (and probably the dsp
legacy), and then suspend to disk during playback.

On the next and each subsequent thawout, the sound is dead even if you
close and repoen the sound.  Only a "cold boot" can fix it.
