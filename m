Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYJVLsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYJVLsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYJVLsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:48:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:5529 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYJVLsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=D1/VBa0aZKY2uonfM9dGLkXfgT4/NsesluAe4N4fOMA0FPBBmzmSogWlCtP/qyMt5Y
         nRQ3hMyI2p8w+cWlJR/yz+4QEwzsg1egA3nQyIBLPeAEQCMl/dCvgFPlyYf6BSPHFHq5
         WAQRzdM9dP2oZGe9WSwdUBmxRKjCo7b5EBgOc=
Message-ID: <94a0d4530810220448x41241926r8f93cde4463b9864@mail.gmail.com>
Date: Wed, 22 Oct 2008 14:48:13 +0300
From: "Felipe Contreras" <felipe.contreras@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Issue with e1000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been trying 2.6.27 and 2.6.27.2, and I haven't been able to use
the e1000 module.

I let my system handle the networking, Network Manager in Fedora 9,
but I also tried this:
ifup eth0
Device eth0 does not seem to be present, delaying initialization.

The module is not loaded automatically so I'm loading it myself,
nothing happens.

I'm also trying this:
modprobe e1000 debug=16

I see nothing special:
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.

Am I missing something?

-- 
Felipe Contreras
