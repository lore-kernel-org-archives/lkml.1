Return-Path: <linux-kernel-owner+w=401wt.eu-S932979AbXBYGp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbXBYGp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 01:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932992AbXBYGp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 01:45:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38463 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbXBYGp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 01:45:56 -0500
Subject: Re: RFC/patch: down_timeout_interruptible()
From: Arjan van de Ven <arjan@infradead.org>
To: =?ISO-8859-1?Q?I=F1aky_P=E9rez-Gonz=E1lez?= 
	<inaky.perez-gonzalez@intel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200702221754.31165.inaky.perez-gonzalez@intel.com>
References: <200702221754.31165.inaky.perez-gonzalez@intel.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 25 Feb 2007 07:45:54 +0100
Message-Id: <1172385954.3265.14.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I gave it a quick try (must admit, not too tested) and it seems that
> the setting of TIF_SIGPENDING without really having a signal queued
> is not having easily visible ugly consequences.


what happens if you get a signal around the time the timeout fires?

