Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbYATXDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbYATXDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 18:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbYATXDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 18:03:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:56860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbYATXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 18:03:46 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: lockd spams syslog after upgrade from 2.6.18 to 2.6.24-rc8
Date: Mon, 21 Jan 2008 00:03:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801210003.35734.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1+yVEthcH+Z5+X6lUo2RwWGFGJTRJfSkQzJ89k
 F4x26uwwqM1Jsl6bFBN5h2suzENhwBfYWscTQoy5Es+EuiS16z
 lfOjxtoGkjgXQuTDn+FzA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

after installation of 2.6.24-rc8 on a local server, the syslog gets spammed 
with "lockd: cannot monitor <some client>"

grep 'lockd: cannot monitor' /var/log/messages | wc -l
136026

in 20 minutes! I restarted the offending client (with 2.6.18.something) for 
mercy reasons now..

Pete
