Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbYFVViK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbYFVViK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbYFVVh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:37:28 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57835 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755739AbYFVVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:37:27 -0400
Message-Id: <20080622213721.925217733@fluff.org.uk>
References: <20080622213648.343882522@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Sun, 22 Jun 2008 22:36:50 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, wim@iguana.be,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 2/3] WATCHDOG: Clean out header of s3c2410_wdt driver.
Content-Disposition: inline; filename=simtec/simtec-drivers-s3c2410-wdt-cleanup1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the changelog from the top of the driver, which
is redundant as this information is more accurately
represented from the revision control holding the
file.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-quilt1/drivers/watchdog/s3c2410_wdt.c
===================================================================
--- linux-2.6.26-rc5-quilt1.orig/drivers/watchdog/s3c2410_wdt.c	2008-06-07 23:10:16.000000000 +0100
+++ linux-2.6.26-rc5-quilt1/drivers/watchdog/s3c2410_wdt.c	2008-06-07 23:10:54.000000000 +0100
@@ -21,18 +21,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * Changelog:
- *	05-Oct-2004	BJD	Added semaphore init to stop crashes on open
- *				Fixed tmr_count / wdt_count confusion
- *				Added configurable debug
- *
- *	11-Jan-2005	BJD	Fixed divide-by-2 in timeout code
- *
- *	25-Jan-2005	DA	Added suspend/resume support
- *				Replaced reboot notifier with .shutdown method
- *
- *	10-Mar-2005	LCVR	Changed S3C2410_VA to S3C24XX_VA
 */
 
 #include <linux/module.h>

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
