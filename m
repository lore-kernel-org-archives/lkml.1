Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384Ab0ATLuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0ATLuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 06:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515Ab0ATLuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 06:50:05 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58964 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760Ab0ATLuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 06:50:04 -0500
Date: Wed, 20 Jan 2010 12:50:23 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       viro@ftp.linux.org.uk
Cc: siccegge@stud.informatik.uni-erlangen.de,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Obsolete config in kernel (epic100) source (CONFIG_BIG_ENDIAN)
Message-ID: <20100120115022.GA3580@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	The epic100 kernel dirver checks the variable
CONFIG_BIG_ENDIAN for turning on byteswapping. This Variable seems to
only have ever existed as a configuration option on the sh64 Platform
and is even there now renamed and no longer existent. SO I fear the
code won't behave as expected.

	I'm not attaching any patch as I'm not sure how to correctly
handle Endianess.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

