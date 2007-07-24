Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbXGXIDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbXGXIDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbXGXIDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:03:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbXGXIDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:03:12 -0400
Date: Tue, 24 Jul 2007 01:02:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-Id: <20070724010224.bbfb82bc.akpm@linux-foundation.org>
In-Reply-To: <Line.LNX.4.64.0707141233490.26711@d.namei>
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 12:37:01 -0400 (EDT) James Morris <jmorris@namei.org> wrote:

> Convert LSM into a static interface

allmodconfig broke

security/built-in.o: In function `rootplug_bprm_check_security':
security/root_plug.c:64: undefined reference to `usb_find_device'
security/root_plug.c:70: undefined reference to `usb_put_dev'

