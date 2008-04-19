Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbYDSM71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbYDSM71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 08:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYDSM7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 08:59:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54733 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbYDSM7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 08:59:18 -0400
Date: Sat, 19 Apr 2008 15:00:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: ioctls are handled by core, support is dead
Message-ID: <20080419130001.GA7810@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wireless api is dead code that can be removed.

---
commit 08118c99165a5e6c0f6f9e5730175a0708b93b0d
tree 58d2216bc9728563b9921efba0bed30f74b80212
parent 72ef967c3bdda42a1b39e533650b1588003cbb08
author Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 14:59:14 +0200
committer Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 14:59:14 +0200

 .../winbond/winbondport/linux/new_wireless.c       |  242 ---------------------
 .../winbond/winbondport/linux/new_wireless.h       |  261 -----------------------
 drivers/net/wireless/winbond/winbondport/wblinux.c |    2 
 3 files changed, 0 insertions(+), 505 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
index 026ac25..f98def1 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
@@ -65,245 +65,3 @@ void FreqToChannelNum(u8 Band, u8 *Chann
 		break;
 	}
 }
-
-int test_get_name(struct net_device *dev,
-			 struct iw_request_info *info, char *name, char *extra)
-{
-	strcpy(name, "w35und");
-	return 0;
-}
-
-int test_set_scan(struct net_device *dev,
-			 struct iw_request_info *info, struct iw_point *srq, char *extra)
-{
-	BUG();
-}
-
-int test_get_scan(struct net_device *dev,
-		  struct iw_request_info *info, struct iw_point *srq, char *extra)
-{
-	BUG();
-}
-
-
-int test_get_freq(struct net_device *dev,
-			 struct iw_request_info *info, struct iw_freq *freq, char *extra)
-{
-	BUG();
-}
-
-int test_set_freq(struct net_device *dev,
-			 struct iw_request_info *info, struct iw_freq *freq, char *extra)
-{
-   DEBUG("SET FREQ\n");
-   return 0;
-}
-
-int test_get_range(struct net_device *dev,
-			  struct iw_request_info *info, struct iw_point *wrq, char *extra)
-{
-	BUG();
-}
-
-int test_get_power(struct net_device *dev,
-			  struct iw_request_info *info, struct iw_param *vwrq, char *extra)
-{
-   vwrq->disabled = 1;
-   return 0;
-}
-
-//get mode desde la estructura interna definida por el original
-int test_get_mode(struct net_device *dev,
-			 struct iw_request_info *info, __u32 *mode, char *extra)
-{
-	BUG();
-
-}
-
-int test_set_mode(struct net_device *dev,
-			 struct iw_request_info *info, __u32 *mode, char *extra)
-{
-	BUG();
-}
-
-int test_set_rate(struct net_device *dev,
-			 struct iw_request_info *info, struct iw_param *rrq, char *extra)
-{
-	BUG();
-}
-
-int test_get_rate(struct net_device *dev,
-			 struct iw_request_info *info, struct iw_param *rrq, char *extra)
-{
-	BUG();
-}
-
-int test_set_rts(struct net_device *dev, struct iw_request_info *info,
-			struct iw_param *rts, char *extra)
-{
-	BUG();
-}
-
-int test_get_rts(struct net_device *dev, struct iw_request_info *info,
-			struct iw_param *rts, char *extra)
-{
-	BUG();
-}
-
-int test_set_frag(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_param *frag, char *extra)
-{
-	BUG();
-}
-
-int test_get_frag(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_param *frag, char *extra)
-{
-	BUG();
-}
-
-int test_set_txpow(struct net_device *dev, struct iw_request_info *info,
-			  struct iw_param *txpower, char *extra)
-{
-	BUG();
-}
-
-int test_get_txpow(struct net_device *dev, struct iw_request_info *info,
-			  struct iw_param *txpower, char *extra)
-{
-	BUG();
-}
-
-int test_set_essid(struct net_device *dev,
-		   struct iw_request_info *info, struct iw_point *data, char *essid)
-{
-	BUG();
-}
-
-/* Segun el original no reporta el ssid conectado, veri los comentarios de codigo ahi */
-int test_get_essid(struct net_device *dev,
-			  struct iw_request_info *info, struct iw_point *data, char *essid)
-{
-	BUG();
-}
-
-int test_get_sens(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_param *sens, char *extra)
-{
-	BUG();
-}
-
-int test_get_nick(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_point *data, char *nick)
-{
-	BUG();
-}
-
-int test_set_encode(struct net_device *dev,
-			   struct iw_request_info *info, struct iw_point *erq, char *key)
-{
-	BUG();
-}
-
-int test_set_encodeext(struct net_device *dev,
-			      struct iw_request_info *info,
-			      union iwreq_data *wrqu,
-			      char *extra)
-{      BUG();
-}
-
-int test_get_encodeext(struct net_device *dev,
-			      struct iw_request_info *info,
-			      union iwreq_data *wrqu,
-			      char *extra)
-{
-
-   return 0;
-}
-
-int test_get_wap(struct net_device *dev,
-			struct iw_request_info *info, struct sockaddr *ap_addr, char *extra)
-{
-	BUG();
-
-}
-int test_set_wap(struct net_device *dev,
-			struct iw_request_info *info, struct sockaddr *ap_addr, char *extra)
-{
-	BUG();
-}
-
-int  test_get_register(struct net_device *dev,    struct iw_request_info *info, struct iw_param *param, char *extra){ return 0; }
-
-int test_set_register(struct net_device *dev,    struct iw_request_info *info, struct iw_param *param, char *extra){ return 0; }       /* ZD1201GIWHOSTAUTH */
-
-int test_get_region(	struct net_device *dev, struct iw_request_info *info,
-				struct iw_point *data, char *region)
-{
-	BUG();
-
-}
-int test_set_region(	struct net_device *dev, struct iw_request_info *info,
-				struct iw_point *data, char *region)
-{
-	BUG();
-}
-//No andan muy bien estos 2
-int test_get_ibss_freq( struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *freq)
-{
-	BUG();
-}
-
-int test_set_ibss_freq(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra)
-{	BUG();
-}
-
-int test_get_ibss_mode(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra)
-
-{
-	BUG();
-}
-
-int test_set_ibss_mode(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra)
-{
-	BUG();
-
-}
-int test_scanning(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra)
-{ BUG();
-}
-
-int test_get_scan_list(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra)
-
-{
-	BUG();
-}
-
-int test_set_pwd(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra)
-{
-	BUG();
-}
-int test_set_ie(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra)
-{
-	BUG();
-}
-int test_get_ver(struct net_device *dev,    struct iw_request_info *info, struct iw_point *param, char *extra)
-{
-	BUG();
-}
-int test_get_ssid_info(struct net_device *dev,    struct iw_request_info *info, struct iw_point *param, char *extra)
-{
-	BUG();
-}
-
-int test_set_genie(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra)
-{
-	BUG();
-}
-
-//crashea aca
-int test_set_auth(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra)
-{
-	BUG();
-}
-
diff --git a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.h b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.h
index 7ea45f5..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.h
+++ b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.h
@@ -1,261 +0,0 @@
-/* Wireless Nuevas */
-#ifndef NEW_WIRELESS_H
-#define NEW_WIRELESS_H
-
-//just in case...
-#ifndef DEBUG_MINE_1
-# undef DEBUG_MINE_1
-#endif
-
-# ifdef DEBUG_MINE_1
-#  define DEBUG( T , args... )  printk( KERN_DEBUG T, ##args)
-#  define DEBUG2( T , args... )  printk( KERN_DEBUG T, ##args)
-# else
-#  define DEBUG( T , args... ) while(0){}
-#  define DEBUG2( T , args... ) while(0){}
-# endif
-
-# define Wb32_RegisterRead				SIOCIWFIRSTPRIV
-# define Wb32_RegisterWrite				SIOCIWFIRSTPRIV + 1
-# define IOCTL_PRIV_SET_REGION			SIOCIWFIRSTPRIV + 2
-# define IOCTL_PRIV_GET_REGION			SIOCIWFIRSTPRIV + 3
-# define IOCTL_PRIV_SET_IBSS_FREQUENCY	SIOCIWFIRSTPRIV + 4
-# define IOCTL_PRIV_GET_IBSS_FREQUENCY	SIOCIWFIRSTPRIV + 5
-# define IOCTL_PRIV_SET_IBSS_MODE		SIOCIWFIRSTPRIV + 6
-# define IOCTL_PRIV_GET_IBSS_MODE		SIOCIWFIRSTPRIV + 7
-# define IOCTL_PRIV_GET_SCAN_LIST		SIOCIWFIRSTPRIV + 8
-# define IOCTL_PRIV_SET_SCAN_LIST		SIOCIWFIRSTPRIV + 9
-
-//Added by WangJS 2005.12.9
-# define IOCTL_PRIV_SET_GENIES			SIOCIWFIRSTPRIV + 10
-//Added by WangJS 2006.6.22
-# define IOCTL_PRIV_GET_DRIVER_VER		SIOCIWFIRSTPRIV + 11
-//Added by WangJS 2005.12.6
-# define IOCTL_PRIV_SET_WPA_PASSWORD		SIOCIWFIRSTPRIV + 12
-//Added by WangJS 2006.6.3
-# define IOCTL_PRIV_GET_SSID_INFO		SIOCIWFIRSTPRIV + 13
-//Added by WangJS 2006.9.7
-//# define IOCTL_PRIV_SET_RATE				SIOCIWFIRSTPRIV + 14
-
-// Autor: Leandro Costantino - Pixart SRL <> : Port from original  Winbound Wireless Driver
-// Distro: Rxart Desktop  kernel 2.6.22-pixart-panda
-//
-# define NICKNAME "IS89C35"
-//RSSI -> Signal / Quality
-# define MIN_RSSI -26
-# define MAX_RSSI -110
-# define AV_RSSI ( MAX_RSSI - MIN_RSSI)
-//Estimation
-# define GET_QUALITY_PERCENTAGE(rssi) (int)(((rssi - MIN_RSSI)*100)/AV_RSSI)
-
-# define KEYS_AVAILABLE 4    //should be ok?
-# define MAX_RATES_BY_VENDOR 11
-# define MAX_KEY_SIZE    13
-# define MIN_KEY_SIZE    5
-# define SSID_MAX_WPA_IE_LEN	40
-
-int test_get_name(struct net_device *dev, struct iw_request_info *info, char *name, char *extra);
-int test_set_scan(struct net_device *dev, struct iw_request_info *info, struct iw_point *srq, char *extra);
-int test_get_scan(struct net_device *dev, struct iw_request_info *info, struct iw_point *srq, char *extra);
-int test_set_freq(struct net_device *dev, struct iw_request_info *info, struct iw_freq *freq, char *extra);
-int test_get_freq(struct net_device *dev, struct iw_request_info *info, struct iw_freq *freq, char *extra);
-int test_get_range(struct net_device *dev,  struct iw_request_info *info, struct iw_point *wrq, char *extra);
-int test_get_power(struct net_device *dev,  struct iw_request_info *info, struct iw_param *vwrq, char *extra);
-int test_get_mode(struct net_device *dev, struct iw_request_info *info, __u32 *mode, char *extra);
-int test_set_mode(struct net_device *dev, struct iw_request_info *info, __u32 *mode, char *extra);
-int test_get_rate(struct net_device *dev, struct iw_request_info *info, struct iw_param *rrq, char *extra);
-int test_set_rate(struct net_device *dev, struct iw_request_info *info, struct iw_param *rrq, char *extra);
-int test_set_rts(struct net_device *dev, struct iw_request_info *info, struct iw_param *rts, char *extra);
-int test_get_rts(struct net_device *dev, struct iw_request_info *info, struct iw_param *rts, char *extra);
-int test_set_frag(struct net_device *dev, struct iw_request_info *info, struct iw_param *frag, char *extra);
-int test_get_frag(struct net_device *dev, struct iw_request_info *info, struct iw_param *frag, char *extra);
-int test_get_sens(struct net_device *dev, struct iw_request_info *info, struct iw_param *sens, char *extra);
-int test_set_txpow(struct net_device *dev, struct iw_request_info *info,struct iw_param *txpow, char *extra);
-int test_get_txpow(struct net_device *dev, struct iw_request_info *info,struct iw_param *txpow, char *extra);
-int test_set_essid(struct net_device *dev, struct iw_request_info *info, struct iw_point *data, char *essid);
-int test_get_essid(struct net_device *dev, struct iw_request_info *info, struct iw_point *data, char *essid);
-int test_get_nick(struct net_device *dev, struct iw_request_info *info, struct iw_point *data, char *nick);
-int test_get_wap(struct net_device *dev,	struct iw_request_info *info, struct sockaddr *ap_addr, char *extra);
-int test_set_wap(struct net_device *dev,	struct iw_request_info *info, struct sockaddr *ap_addr, char *extra);
-
-//PRIVATES
-int  test_get_register(struct net_device *dev,    struct iw_request_info *info, struct iw_param *param, char *extra);
-int test_set_register(struct net_device *dev,    struct iw_request_info *info, struct iw_param *param, char *extra);
-int test_get_region( struct net_device *dev, struct iw_request_info *info, struct iw_point *data, char *region);
-int test_set_region( struct net_device *dev, struct iw_request_info *info,   struct iw_point *data, char *region);
-int test_get_ibss_freq(struct net_device *dev,    struct iw_request_info *info,	struct iw_point *data, char *region);
-int test_set_ibss_freq(struct net_device *dev,    struct iw_request_info *info,	struct iw_point *data, char *region);
-int test_get_ibss_mode(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra);
-int test_set_ibss_mode(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra);
-int test_get_scan_list(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra);
-int test_scanning(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra);
-
-/* TKIP Support inside the card, dont need suplicant in this case */
-int test_set_pwd(struct net_device *dev, struct iw_request_info *info, struct iw_point *data, char *extra);
-int test_set_ie(struct net_device *dev, struct iw_request_info *info, struct iw_point *data, char *extra);
-int test_set_genie(struct net_device *dev, struct iw_request_info *info, struct iw_point *data, char *extra);
-int test_get_ver(struct net_device *dev, struct iw_request_info *info, struct iw_point *param, char *extra);
-int test_get_ssid_info(struct net_device *dev, struct iw_request_info *info, struct iw_point *param, char *extra);
-int test_set_encode(struct net_device *dev, struct iw_request_info *info, struct iw_point *erq, char *key);
-int test_get_encode(struct net_device *dev, struct iw_request_info *info, struct iw_point *erq, char *key);
-int test_set_encodeext(struct net_device *dev, struct iw_request_info *info, union iwreq_data *wrqu,char *extra);
-int test_get_encodeext(struct net_device *dev, struct iw_request_info *info,union iwreq_data *wrqu,char *extra);
-int test_set_auth(struct net_device *dev,    struct iw_request_info *info, struct iw_point *data, char *extra);
-
-#ifdef DEBUG_MINE_1
-   struct iw_statistics *test_get_wireless_stats(struct net_device *ndev);
-#endif
-
-static const iw_handler test_iw_handler[] =
-{
-   (iw_handler) NULL,//test_config_commit,	/* SIOCSIWCOMMIT */
-     (iw_handler) test_get_name,    	/* SIOCGIWNAME */
-     (iw_handler) NULL,			/* SIOCSIWNWID */
-     (iw_handler) NULL,			/* SIOCGIWNWID */
-     (iw_handler) test_set_freq,		/* SIOCSIWFREQ */
-     (iw_handler) test_get_freq,		/* SIOCGIWFREQ */
-     (iw_handler) test_set_mode,		/* SIOCSIWMODE */
-     (iw_handler) test_get_mode,		/* SIOCGIWMODE */
-     (iw_handler) NULL,                  	/* SIOCSIWSENS */
-     (iw_handler) test_get_sens,           		/* SIOCGIWSENS */
-     (iw_handler) NULL,			/* SIOCSIWRANGE */
-     (iw_handler) test_get_range,           /* SIOCGIWRANGE */
-     (iw_handler) NULL,			/* SIOCSIWPRIV */
-     (iw_handler) NULL,			/* SIOCGIWPRIV */
-     (iw_handler) NULL,			/* SIOCSIWSTATS */
-     (iw_handler) NULL,			/* SIOCGIWSTATS */
-     (iw_handler) NULL,			/* SIOCSIWSPY */
-     (iw_handler) NULL,			/* SIOCGIWSPY */
-     (iw_handler) NULL,			/* -- hole -- */
-     (iw_handler) NULL,			/* -- hole -- */
-     (iw_handler) test_set_wap,		/* SIOCSIWAP */
-     (iw_handler) test_get_wap,		/* SIOCGIWAP */
-     (iw_handler) NULL,			/* -- hole -- */
-     (iw_handler) NULL,       		/* SIOCGIWAPLIST */
-     (iw_handler) test_set_scan,		/* SIOCSIWSCAN */
-     (iw_handler) test_get_scan,		/* SIOCGIWSCAN */
-     (iw_handler) test_set_essid,		/* SIOCSIWESSID */
-     (iw_handler) test_get_essid,		/* SIOCGIWESSID */
-     (iw_handler) NULL,         		/* SIOCSIWNICKN */
-     (iw_handler) test_get_nick, 		/* SIOCGIWNICKN */
-     (iw_handler) NULL,			/* -- hole -- */
-     (iw_handler) NULL,			/* -- hole -- */
-     (iw_handler) test_set_rate,		/* SIOCSIWRATE */
-     (iw_handler) test_get_rate,		/* SIOCGIWRATE */
-     (iw_handler) test_set_rts,		/* SIOCSIWRTS */
-     (iw_handler) test_get_rts,		/* SIOCGIWRTS */
-     (iw_handler) test_set_frag,		/* SIOCSIWFRAG */
-     (iw_handler) test_get_frag,		/* SIOCGIWFRAG */
-
-     (iw_handler) test_set_txpow,         		/* SIOCSIWTXPOW */
-     (iw_handler) test_get_txpow,          		/* SIOCGIWTXPOW */
-     (iw_handler) NULL,		/* SIOCSIWRETRY */
-     (iw_handler) NULL,		/* SIOCGIWRETRY */
-     (iw_handler) test_set_encode,		/* SIOCSIWENCODE */
-     (iw_handler) NULL,		/* SIOCGIWENCODE */
-     (iw_handler) NULL,		/* SIOCSIWPOWER */
-     (iw_handler) test_get_power,		/* SIOCGIWPOWER */ // VER EL REGISTRO
-     (iw_handler) NULL,                      /* -- hole -- */
-     (iw_handler) NULL,                      /* -- hole -- */
-     (iw_handler) test_set_genie,                      /* SIOCSIWGENIE */
-     (iw_handler) NULL,                      /* SIOCGIWGENIE */
-     (iw_handler) test_set_auth,             /* SIOCSIWAUTH */
-     (iw_handler) NULL,             /* SIOCGIWAUTH */
-     (iw_handler) test_set_encodeext,        /* SIOCSIWENCODEEXT */
-     (iw_handler) test_get_encodeext,        /* SIOCGIWENCODEEXT */
-     (iw_handler) NULL,                      /* SIOCSIWPMKSA */
-};
-
-static const iw_handler test_private_handler[] =
-{
-
-   (iw_handler) test_get_register,
-     (iw_handler) test_set_register,
-     (iw_handler) test_set_region,                     /* nothing to get */
-     (iw_handler) test_get_region,
-     (iw_handler) test_set_ibss_freq,
-     (iw_handler) test_get_ibss_freq,
-     (iw_handler) test_set_ibss_mode,
-     (iw_handler) test_get_ibss_mode,
-
-     (iw_handler) test_get_scan_list,
-     (iw_handler) test_scanning,
-     (iw_handler) test_set_ie,
-     (iw_handler) test_get_ver,
-     (iw_handler) test_set_pwd,
-
-     (iw_handler) test_get_ssid_info,
-     //     (iw_handler) test_set_rate,
-};
-
-static const struct iw_priv_args test_private_args[] =
-{
-     { Wb32_RegisterRead, IW_PRIV_TYPE_NONE,	IW_PRIV_TYPE_CHAR | 4 , "get_register" },
-     { Wb32_RegisterWrite, IW_PRIV_TYPE_CHAR | 4, 0, "set_register" },
-     { IOCTL_PRIV_SET_REGION, IW_PRIV_TYPE_CHAR | 15, IW_PRIV_TYPE_NONE, "set_region" },
-     { IOCTL_PRIV_GET_REGION, IW_PRIV_TYPE_NONE, IW_PRIV_TYPE_CHAR | 15 , "get_region" },
-     { IOCTL_PRIV_SET_IBSS_FREQUENCY, IW_PRIV_TYPE_INT | 1, 0, "set_ibss_freq" },
-     { IOCTL_PRIV_GET_IBSS_FREQUENCY, IW_PRIV_TYPE_NONE, IW_PRIV_TYPE_INT | 1, "get_ibss_freq" },
-     { IOCTL_PRIV_SET_IBSS_MODE, IW_PRIV_TYPE_CHAR | 10, IW_PRIV_TYPE_NONE, "set_ibss_mode" },
-     { IOCTL_PRIV_GET_IBSS_MODE, IW_PRIV_TYPE_NONE, IW_PRIV_TYPE_CHAR | 10, "get_ibss_mode" },
-
-     { IOCTL_PRIV_GET_SCAN_LIST,IW_PRIV_TYPE_NONE, IW_PRIV_TYPE_CHAR | 15, "scan_list"},
-     { IOCTL_PRIV_SET_SCAN_LIST, IW_PRIV_TYPE_BYTE | 0, IW_PRIV_TYPE_NONE, "scanning"},
-     { IOCTL_PRIV_SET_GENIES, IW_PRIV_TYPE_CHAR | 15, IW_PRIV_TYPE_NONE, "set_ie"}, //Added by WangJS 2005.12.9, modifed 2005.12.27
-     { IOCTL_PRIV_GET_DRIVER_VER,IW_PRIV_TYPE_NONE,IW_PRIV_TYPE_CHAR | 15, "get_ver"}, //Added by WangJS 2006.6.22
-     { IOCTL_PRIV_SET_WPA_PASSWORD, IW_PRIV_TYPE_CHAR | 15, IW_PRIV_TYPE_NONE, "set_pwd"}, //Added by WangJS 2005.12.8, modified 2005.12.27
-     { IOCTL_PRIV_GET_SSID_INFO,IW_PRIV_TYPE_NONE,IW_PRIV_TYPE_CHAR | 15, "get_ssid_info"}, //Added by WangJS 2006.6.30
-
-};
-
-static const struct iw_handler_def test_iw_handlers =
-{
-
-   .num_standard           = ARRAY_SIZE(test_iw_handler),
-   .num_private            = ARRAY_SIZE(test_private_handler),
-   .num_private_args       =ARRAY_SIZE(test_private_args),
-   .standard               = (iw_handler *)test_iw_handler,
-     .private                =(iw_handler *)test_private_handler,
-     .private_args           =(struct iw_priv_args *) test_private_args,
-     #ifdef DEBUG_MINE_1
-     .get_wireless_stats     = test_get_wireless_stats,
-     #else
-     .get_wireless_stats     = NULL,
-     #endif
-};
-
-// channel number -> channel freq.
-void ChannelNumToFreq(u8 NetworkType, u8 ChannelNumber, u32 *freq);
-
-// channel freq. -> channel number
-void FreqToChannelNum(u8 Band, u8 *ChannelNumber, u32 freq);
-
-#ifdef DEBUG_MINE_1
-struct iw_statistics *test_get_wireless_stats(struct net_device *dev) {
-
-   PADAPTER Adapter = dev->priv;
-   struct iw_statistics *iw_stats = &Adapter->iw_stats;
-//   unsigned int i, count;
-  unsigned int t_rssi, t_qual;
-
-   memset(iw_stats, 0, sizeof(struct iw_statistics));
-
-   //SIMULATION for test......
-
-   //lock..?
-
-   t_rssi = t_qual = 0;
-
-   iw_stats->qual.updated = IW_QUAL_NOISE_INVALID;
-
-   iw_stats->qual.qual = 99;
-   iw_stats->qual.level = 99;
-   iw_stats->qual.updated |=
-     IW_QUAL_QUAL_UPDATED|IW_QUAL_LEVEL_UPDATED;
-
-   return iw_stats;
-}
-#endif
-
-//EOF
-#endif
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index a133c9b..742b2d1 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -188,8 +188,6 @@ WBLINUX_Destroy(PADAPTER Adapter)
 {
 	PWBLINUX pWbLinux = &Adapter->WbLinux;
 
-	DEBUG2("UNregistering....\n");
-
 	WBLINUX_stop( Adapter );
 	OS_SPIN_LOCK_FREE( &pWbNdis->SpinLock );
 	unregister_netdev( pWbLinux->netdev );

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
