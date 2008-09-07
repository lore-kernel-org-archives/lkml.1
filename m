Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYIGVNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYIGVNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 17:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYIGVMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 17:12:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:51005 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYIGVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 17:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ICL0QRbm1ggW7+SfzWoWnK7uAjJGxBKS52cI5yoih7CP3sTvBEZjWS+CZ9oXzoZdEN
         zTgyPmNeimBxtVafdZaeizOAVnoAN4knA+X1i9i0m2SIse35Rg22wcDDzSv9HOW4luPV
         LMYGL+IqAGNPQrizWFYrX41J7lNS/YTSp5SsU=
Date: Mon, 8 Sep 2008 01:14:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, andrea@cpushare.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] seccomp: drop now bogus dependency on PROC_FS
Message-ID: <20080907211439.GA18586@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seccomp is prctl(2)-driven now.

