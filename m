Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbYAVIBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbYAVIBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 03:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYAVIBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 03:01:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:50842 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYAVIBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 03:01:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lHDE/OT07nOfH6NZGoYd785IQvFrhaSH1EVETJb06sPPTJRLAD5mqVdjHiygnxnNSszAjspE6ytkFasWv8hmJwll0AGBCDOCA2ctAjVRKh2uAoW1/HOQlMHlXwSpuW312V9eHSQ3gUrUzctUzb1PkR2sLLqGvNNL6hxa89WYasQ=
Message-ID: <38b2ab8a0801220001t284c41bdo42b534599249df2a@mail.gmail.com>
Date: Tue, 22 Jan 2008 09:01:10 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: vojtech@suse.cz
Subject: Linux and remote control device
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to add support for my Infrared remote control to Linux.

So far I only see LIRCD project that make the kernel support
such device but I'm not sure if this project is the best choice
since it's not part of mainline kernels. And there are certainly
good reasons which I'm not aware of.

Another possibility is to make the remote controle device an input
device. But I see several flaws:

- The IR receiver on my board can't be use as a transmitter any
more
- All scancodes are embedded in the kernel.

Do you think it's still the way to go despite the 2 points raised above ?

Thanks !
-- 
Francis
