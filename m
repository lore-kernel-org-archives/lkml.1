Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYJXUg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYJXUg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYJXUgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:36:47 -0400
Received: from nebensachen.de ([195.34.83.29]:54524 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYJXUgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:36:46 -0400
X-Hashcash: 1:20:081024:gregkh@suse.de::569hjNB/g1LXn2PR:000CGUZ
X-Hashcash: 1:20:081024:linux-kernel@vger.kernel.org::A14/55KFyQ//1L1D:00000000000000000000000000000000054Zt
X-Hashcash: 1:20:081024:stable@kernel.org::ChiTOqY78exS0+/t:000000000000000000000000000000000000000000002maM
X-Hashcash: 1:20:081024:jejb@kernel.org::d62Zd0eCynI61iS5:002LmM
X-Hashcash: 1:20:081024:jmforbes@linuxtx.org::oh3s/oyVzVC8nz4a:00000000000000000000000000000000000000000D8Nu
X-Hashcash: 1:20:081024:zwane@arm.linux.org.uk::q6ql0eSwuMZ+2OuS:000000000000000000000000000000000000000LQmJ
X-Hashcash: 1:20:081024:tytso@mit.edu::bXG7ogFUkmkBH1jI:00006SpX
X-Hashcash: 1:20:081024:rdunlap@xenotime.net::WQULTFkdtfsUdDss:000000000000000000000000000000000000000001UGK
X-Hashcash: 1:20:081024:davej@redhat.com::I7dXCN24ropG+3ne:07YzH
X-Hashcash: 1:20:081024:chuckw@quantumlinux.com::pfE5cM5xR6X8DuVK:000000000000000000000000000000000000000YB+
X-Hashcash: 1:20:081024:reviews@ml.cw.f00f.org::HeSMXpq6hJGiIVdk:0000000000000000000000000000000000000001Ou5
X-Hashcash: 1:20:081024:mkrufky@linuxtv.org::VKZY2iaqCEgWR37D:0000000000000000000000000000000000000000002Xwc
X-Hashcash: 1:20:081024:cebbert@redhat.com::3cjPfNvRFduaOc8B:00000000000000000000000000000000000000000001Uc0
X-Hashcash: 1:20:081024:cavokz@gmail.com::th4TE+u1zYyEvk8p:00yvz
X-Hashcash: 1:20:081024:w@1wt.eu::oPEHypfvhv2ghXn5:000000000M/cT
X-Hashcash: 1:20:081024:rbranco@la.checkpoint.com::5rg0Goj/FhmwUQjR:0000000000000000000000000000000000003hu7
X-Hashcash: 1:20:081024:jake@lwn.net::yMy/k1+secMV9EYt:000001uNL
X-Hashcash: 1:20:081024:eteo@redhat.com::aKkFYa5/61hQmJOk:005lDX
X-Hashcash: 1:20:081024:torvalds@linux-foundation.org::wQeeJi/MrJLOszxO:000000000000000000000000000000004the
X-Hashcash: 1:20:081024:akpm@linux-foundation.org::mwHGf/X0e/zUkblK:0000000000000000000000000000000000007dkQ
X-Hashcash: 1:20:081024:alan@lxorguk.ukuu.org.uk::+rH0X8hGzXpKP417:000000000000000000000000000000000000085eF
X-Hashcash: 1:20:081024:me@bobcopeland.com::N15HS74kIFOIQUAb:00000000000000000000000000000000000000000000W/3
X-Hashcash: 1:20:081024:linville@tuxdriver.com::S+RmMgUSqPxKL0m5:0000000000000000000000000000000000000006ciO
From: Elias Oltmanns <eo@nebensachen.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch 27/27] ath5k: fix suspend-related oops on rmmod
References: <20081024042023.054190751@mini.kroah.org>
	<20081024043530.GB30828@kroah.com>
Date: Fri, 24 Oct 2008 22:36:24 +0200
Message-ID: <87ej253f3r.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us 
> know.
>
> ------------------
> From: Bob Copeland <me@bobcopeland.com>
>
> commit 8bdd5b9c6bd53add260756b6673a0545fbdbba21 upstream
>
> Based on a patch by Elias Oltmanns, we call ath5k_init in resume even
> if we didn't previously open the device.  Besides starting up the
> device unnecessarily, this also causes an oops on rmmod because
> mac80211 will not invoke ath5k_stop and softirqs are left running after
> the module has been unloaded.  Add a new state bit, ATH_STAT_STARTED,
> to indicate that we have been started up.
>
> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

I've done some more testing and I'm ashamed to say that this patch is
incomplete and does indeed introduce a regression itself. Having only
just sent the fix to John, I'm afraid this patch has to be deferred for
the next stable release since the required fix is not likely to hit
Linus' tree in time. Anyway, I'm adding my patch and the changelog entry
by way of explanation.

Regards,

Elias

From: Elias Oltmanns <eo@nebensachen.de>
Subject: [PATCH] ath5k: Reset key cache on interface up, thus fixing resume

After a s2ram / resume cycle, resetting the key cache does not work
unless it is deferred until after the hardware has been reinitialised by
a call to ath5k_hw_reset(). This fixes a regression introduced in commit
8bdd5b9c6bd53add260756b6673a0545fbdbba21 (ath5k: fix suspend-related
oops on rmmod).

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 base.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 0f1d6bd..8acf0ce 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -688,16 +688,6 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		goto err_irq;
 	ath5k_led_enable(sc);
 
-	/*
-	 * Reset the key cache since some parts do not
-	 * reset the contents on initial power up or resume.
-	 *
-	 * FIXME: This may need to be revisited when mac80211 becomes
-	 *        aware of suspend/resume.
-	 */
-	for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
-		ath5k_hw_reset_key(ah, i);
-
 	return 0;
 err_irq:
 	free_irq(pdev->irq, sc);
@@ -737,13 +727,6 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 		__set_bit(ATH_STAT_MRRETRY, sc->status);
 
 	/*
-	 * Reset the key cache since some parts do not
-	 * reset the contents on initial power up.
-	 */
-	for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
-		ath5k_hw_reset_key(ah, i);
-
-	/*
 	 * Collect the channel list.  The 802.11 layer
 	 * is resposible for filtering this list based
 	 * on settings like the phy mode and regulatory
@@ -2202,7 +2185,8 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 static int
 ath5k_init(struct ath5k_softc *sc, bool is_resume)
 {
-	int ret;
+	struct ath5k_hw *ah = sc->ah;
+	int ret, i;
 
 	mutex_lock(&sc->lock);
 
@@ -2235,10 +2219,17 @@ ath5k_init(struct ath5k_softc *sc, bool is_resume)
 	if (ret)
 		goto done;
 
+	/*
+	 * Reset the key cache since some parts do not reset the
+	 * contents on initial power up or resume from suspend.
+	 */
+	for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
+		ath5k_hw_reset_key(ah, i);
+
 	__set_bit(ATH_STAT_STARTED, sc->status);
 
 	/* Set ack to be sent at low bit-rates */
-	ath5k_hw_set_ack_bitrate_high(sc->ah, false);
+	ath5k_hw_set_ack_bitrate_high(ah, false);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
 			msecs_to_jiffies(ath5k_calinterval * 1000)));
