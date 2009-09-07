Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbZIGH5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbZIGH5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZIGH5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:57:19 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:24741 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZIGH5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:57:18 -0400
Message-Id: <4AA4D8FE0200007800013B79@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 07 Sep 2009 08:57:18 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <vandrove@vc.cvut.cz>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ncpfs: fix selection of NLS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>In order for nls_base to really be compilable as a module, the select
>from ncpfs needs to be corrected: Boolean sub-options of tristate
>options selecting another tristate option should not do the select
>themselves, as that forces the selected option to Y. Instead, a
>conditional select in the base tristate option is needed.

Actually, I'd like to withdraw that patch, as I was misguided by something
(not sure what) here: There's no need to move the select around.

Jan

