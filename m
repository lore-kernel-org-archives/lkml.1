Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbZKYODm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbZKYODm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbZKYODl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:03:41 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:49686 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbZKYODk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:03:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GT1prN+emhJcI9TU3bbyoGKCOfY5h8ALv6kwWsB046kkwpiRK9yIfMQKQbJvRGAF18
         Y/xg3z/oUvue243125qIuaYaVqdNviVAcLSN+E3e+YqmdtBjVXZx/hzL3YIuP9E/eLpC
         G/3dsUYCTATT5WdG83cq+3ub1BBFVznL9dfik=
Date: Wed, 25 Nov 2009 11:01:52 -0300
From: Rudy Matela <rudy.matela@gmail.com>
To: mike.mclagan@linux.org, netdev@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Frame Relay/DLCI coding style corrections.
Message-ID: <20091125140152.GA11436@vacuum.larces.uece.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frame Relay/DLCI coding style corrections.

Added a space separating some keywords (if/while) from the following
parenthesis to conform to the CodingStyle.

Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
---

diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 15d353f..421d071 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -77,7 +77,7 @@ static int dlci_header(struct sk_buff *skb, struct net_device *dev,
 	dlp = netdev_priv(dev);
 
 	hdr.control = FRAD_I_UI;
-	switch(type)
+	switch (type)
 	{
 		case ETH_P_IP:
 			hdr.IP_NLPID = FRAD_P_IP;
@@ -130,7 +130,7 @@ static void dlci_receive(struct sk_buff *skb, struct net_device *dev)
 		dev->stats.rx_errors++;
 	}
 	else
-		switch(hdr->IP_NLPID)
+		switch (hdr->IP_NLPID)
 		{
 			case FRAD_P_PADDING:
 				if (hdr->NLPID != FRAD_P_SNAP)
@@ -208,7 +208,7 @@ static int dlci_config(struct net_device *dev, struct dlci_conf __user *conf, in
 
 	if (!get)
 	{
-		if(copy_from_user(&config, conf, sizeof(struct dlci_conf)))
+		if (copy_from_user(&config, conf, sizeof(struct dlci_conf)))
 			return -EFAULT;
 		if (config.flags & ~DLCI_VALID_FLAGS)
 			return(-EINVAL);
@@ -222,7 +222,7 @@ static int dlci_config(struct net_device *dev, struct dlci_conf __user *conf, in
 
 	if (get)
 	{
-		if(copy_to_user(conf, &dlp->config, sizeof(struct dlci_conf)))
+		if (copy_to_user(conf, &dlp->config, sizeof(struct dlci_conf)))
 			return -EFAULT;
 	}
 
@@ -238,7 +238,7 @@ static int dlci_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	dlp = netdev_priv(dev);
 
-	switch(cmd)
+	switch (cmd)
 	{
 		case DLCI_GET_SLAVE:
 			if (!*(short *)(dev->dev_addr))
@@ -417,7 +417,7 @@ static int dlci_ioctl(unsigned int cmd, void __user *arg)
 	if (!capable(CAP_NET_ADMIN))
 		return(-EPERM);
 
-	if(copy_from_user(&add, arg, sizeof(struct dlci_add)))
+	if (copy_from_user(&add, arg, sizeof(struct dlci_add)))
 		return -EFAULT;
 
 	switch (cmd)
@@ -426,7 +426,7 @@ static int dlci_ioctl(unsigned int cmd, void __user *arg)
 			err = dlci_add(&add);
 
 			if (!err)
-				if(copy_to_user(arg, &add, sizeof(struct dlci_add)))
+				if (copy_to_user(arg, &add, sizeof(struct dlci_add)))
 					return -EFAULT;
 			break;
 
