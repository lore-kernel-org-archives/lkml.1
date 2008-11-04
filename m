Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbYKDXtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbYKDXtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbYKDXjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:39:41 -0500
Received: from mx1.suse.de ([195.135.220.2]:47625 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443AbYKDXjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:39:40 -0500
Date: Tue, 4 Nov 2008 15:32:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Len Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 32/57] scx200_i2c: Add missing class parameter
Message-ID: <20081104233207.GG659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scx200_i2c-add-missing-class-parameter.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

commit 4a029abee0f1d69cb0445657d6fa5a38597bd17d upstream

The scx200_i2c driver is missing the .class parameter, which means no
i2c drivers are willing to probe for devices on the bus and attach to
them.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/i2c/busses/scx200_i2c.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/scx200_i2c.c
+++ b/drivers/i2c/busses/scx200_i2c.c
@@ -81,6 +81,7 @@ static struct i2c_algo_bit_data scx200_i
 
 static struct i2c_adapter scx200_i2c_ops = {
 	.owner		   = THIS_MODULE,
+	.class             = I2C_CLASS_HWMON | I2C_CLASS_SPD,
 	.id		   = I2C_HW_B_SCX200,
 	.algo_data	   = &scx200_i2c_data,
 	.name	= "NatSemi SCx200 I2C",

-- 
