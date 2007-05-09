Return-Path: <linux-kernel-owner+w=401wt.eu-S968928AbXEIBpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968928AbXEIBpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968447AbXEIBo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:44:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49097
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S968428AbXEIBo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:44:57 -0400
Date: Tue, 08 May 2007 18:44:58 -0700 (PDT)
Message-Id: <20070508.184458.21594839.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: multi-second freezes with current GIT?
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've been noticing this off and on for the past week or so.

The system seems to jam up for several seconds, anything that would
need to read from disk just sits there during this time.  I think it's
correlated with generating a lot of dirty write data.

My mouse moves around in X etc. so it really is only processes that
need to read from disk that get stuck.

Perhaps it's a side effect of those dirty ratio changes Linus made to
start off the 2.6.22 merge cycle?
