Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYAINcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYAINcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYAINck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:32:40 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45430 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYAINcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:32:39 -0500
To: kzak@redhat.com
CC: jengelh@computergmbh.de, miklos@szeredi.hu, haveblue@us.ibm.com,
       akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080109132610.GJ3926@petra.dvoda.cz> (message from Karel Zak on
	Wed, 9 Jan 2008 14:26:10 +0100)
Subject: Re: [patch 5/9] unprivileged mounts: allow unprivileged bind mounts
References: <20080108113502.184459371@szeredi.hu> <20080108113626.895583537@szeredi.hu> <1199815958.9834.58.camel@localhost> <E1JCJoQ-0003g9-Nk@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0801091340270.29244@fbirervta.pbzchgretzou.qr> <20080109132610.GJ3926@petra.dvoda.cz>
Message-Id: <E1JCb2G-0005pD-FY@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jan 2008 14:32:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     case EMFILE:
>       error ("mount table full"); break;

OK, we could go with EMFILE, but the message should be changed to
something like "maximum unprivileged mount count exceeded".

Miklos
