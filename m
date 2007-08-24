Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbXHXURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbXHXURl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXHXURc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 16:17:32 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50762
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752047AbXHXURc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 16:17:32 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: What's up with CONFIG_BLK_DEV?
Date: Fri, 24 Aug 2007 15:17:28 -0500
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241517.28475.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_BLOCK disables the block layer.
CONFIG_BLK_DEV disables the block devices.

Is there _ever_ a time you want the block layer but no block devices?

(I ask because this is the first time I've had to add a symbol to my User Mode 
Linux miniconfig since 2.6.12, and I can't figure out what the actual purpose 
of this symbol is.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
