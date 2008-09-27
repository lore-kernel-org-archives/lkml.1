Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYI0Can@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYI0Can (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYI0C2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:28:21 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:54617 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYI0C2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:28:10 -0400
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 6/6] file capabilities: remove needless (?) bprm_clear_caps calls
Date: Fri, 26 Sep 2008 22:27:52 -0400
Message-Id: <1222482472-12847-3-git-send-email-serue@us.ibm.com>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <1222482472-12847-2-git-send-email-serue@us.ibm.com>
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com>
 <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com>
 <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com>
 <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com>
 <c9c64bbdfd3f1c665f0d1b08b82f77622be701cc.1222451103.git.serue@us.ibm.com>
 <06b2774a667bc535442305193417ff1a479ef1aa.1222451103.git.serue@us.ibm.com>
 <d57038cdc6b35c2522771e8ed5d5d59ce991a6e1.1222451103.git.serue@us.ibm.com>
 <1222482472-12847-2-git-send-email-serue@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

