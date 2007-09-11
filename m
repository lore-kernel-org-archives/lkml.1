Return-Path: <linux-kernel-owner+w=401wt.eu-S1764626AbXIKVGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764626AbXIKVGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXIKVGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:06:32 -0400
Received: from 251.4.221.87.dynamic.jazztel.es ([87.221.4.251]:39664 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758141AbXIKVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:06:31 -0400
Date: Tue, 11 Sep 2007 22:56:32 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: perex@suse.cz
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/4] Several sound drivers: Use list_for_each_entry(_safe)
Message-ID: <20070911205632.GF8592@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	perex@suse.cz, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each_entry(_safe) instead of list_for_each(_safe) in the
following sound drivers/code:

Generic AC97 mixer/modem module (OSS)
ESS Maestro 1/2/2E Sound Card
Intel HD Audio
Routines for effect processor FX8010

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
