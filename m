Return-Path: <linux-kernel-owner+w=401wt.eu-S934267AbXEESPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267AbXEESPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934280AbXEESPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:15:18 -0400
Received: from h80ad2754.async.vt.edu ([128.173.39.84]:60705 "EHLO
	h80ad2754.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934267AbXEESPR (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:15:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
In-Reply-To: Your message of "Sat, 05 May 2007 01:49:55 PDT."
             <20070505014955.8f3990b5.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178388611_3690P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 05 May 2007 14:10:11 -0400
Message-ID: <4521.1178388611@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178388611_3690P
Content-Type: text/plain; charset=us-ascii

On Sat, 05 May 2007 01:49:55 PDT, Andrew Morton said:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/

'make silentoldconfig' produces:

SCSI debugging host simulator (SCSI_DEBUG) [N/m/y/?] n
ESP Scsi Driver Core (SCSI_ESP_CORE) [N/m/y] (NEW) ?

Sorry, no help available for this option yet.

ESP Scsi Driver Core (SCSI_ESP_CORE) [N/m/y] (NEW) 

and grovelling around inside origin.patch find a nicely done driver calling
itself esp_scsi[ch].  Unfortunately, the only hint as to what devices this
applies to (or whether it's in fact a new driver *CORE*, similar to the
recent FireWire and mac80211 driver core rewrites), is found in this array:

static const char *esp_chip_names[] = {
       "ESP100",
       "ESP100A",
       "ESP236",
       "FAS236",
       "FAS100A",
       "FAST",
       "FASHME",
};

I'm presuming some Kconfig help will land before the 2.6.22 merge window
closes? :)


--==_Exmh_1178388611_3690P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGPMiDcC3lWbTT17ARAqOvAKCzyczzvXze3WIyM63hbq9+ENz4NQCfSujk
EpwFnV+r2b7Y5IV4ugrugnc=
=lIYJ
-----END PGP SIGNATURE-----

--==_Exmh_1178388611_3690P--
