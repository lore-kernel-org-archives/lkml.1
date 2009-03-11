Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbZCKV6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbZCKV6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZCKV5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:57:52 -0400
Received: from smtp106.biz.mail.mud.yahoo.com ([68.142.200.254]:33110 "HELO
	smtp106.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750742AbZCKV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:57:52 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: AuV0MykVM1mgzyndbzsPb3gRexGp3DcCRKMKUWiK5X11i6eEOJyOYRKFyRvB6o9DexZ44k_dckaFVOqpQeKX_Ii9xzLmp0C9ofZPH2j4Ovl0fSLVtHMO9RXs589uUxGHdrY0yHYmdq.aNtZV43akb6Ptg8Mtz3VphMRfyUinxXm5FrByoP0oCiyqUK8fgd5bY7kKik2igyiqZaMj4Pd7.4slaw--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 00/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:55:36 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111455.37291.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are an implementation of generic gpio for the Freescale 
Coldfire family of processors (m68knommu).   It uses gpiolib and provides both 
fast inline operations when the gpio is a compile time constant and slower 
outline operations dispatched via gpiolib when the gpio is a variable. 

There are also hooks for implementing pin multiplexing but that part isnt 
finished yet.
 
-- 
Steven King -- sfking at fdwdc dot com
