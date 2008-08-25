Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYHYTiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYHYTiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbYHYThk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:37:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:11215 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbYHYThj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:mime-version:x-mailer
         :content-transfer-encoding:sender:message-id;
        b=hTmuWeAa8bJflt3MwcgAJykQMaUdq7c1gP+sbyOzcjsTuDTfkGlPmUI6ilRDlBTbs8
         mp9sWQUkCH3WJFkohlsTPcPe71PTjld2TgEWzpF6fx3TRQeIoJRk6+St9St17N0wkn7n
         sT49Jlgg9di2OmI/sQYG/EF0bJeGE4iJZoUxI=
User-Agent: quilt/0.46-1
Date: Mon, 25 Aug 2008 21:14:27 +0200
From: Remy Bohmer <linux@bohmer.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       u-boot@lists.denx.de, sam@ravnborg.org
Cc: Stefan Roese <sr@denx.de>
Subject: [patch 0/2] Several U-boot uImage building patches
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Message-ID: <48b309fb.1701d00a.4e74.ffffa8d7@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here follows a series of 2 patches that provide some additional functionality
to building Linux kernel uImages for U-boot:
* Make it possible to base uImage on the non-compressed kernel 'Image' instead
  of 'zImage'.
* Add support for the new U-boot uImage file format, called FIT. This will allow
  a kernel to be build directly in this new format instead of the legacy format,
  IF the proper tools are available (dtc v1.2.0 and mkimage 1.3.3; dtc is
  checked by version-number, the proper mkimage is detected by cmd-line
  options, it must provide a '-f' option)

  If older, or improper tools are detected, then the Legacy style image is
  build after issuing a warning message.

Signed-off-by: Remy Bohmer <linux@bohmer.net>
-- 

