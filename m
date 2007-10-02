Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbXJBLew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbXJBLew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbXJBLen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:34:43 -0400
Received: from snape.gogi.tv ([217.160.142.238]:1465 "EHLO snape.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbXJBLem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:34:42 -0400
From: Giuliano Gagliardi <gogi-k@gogi.tv>
Reply-To: gogi-k@gogi.tv
To: linux-kernel@vger.kernel.org
Subject: Re: One process with multiple user ids.
User-Agent: KMail/1.9.7
References: <200710021256.08469.gogi-k@gogi.tv> <Pine.LNX.4.64.0710021322110.7130@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710021322110.7130@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 2 Oct 2007 13:34:34 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200710021334.34950.gogi-k@gogi.tv>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007, Jan Engelhardt wrote:
> On Oct 2 2007 12:56, Giuliano Gagliardi wrote:
> >I have a server that has to switch to different user ids, but because it
> > does other complex things, I would rather not have it run as root. I only
> > need the server to be able to switch to certain pre-defined user ids.
>
> All you need is CAP_SETUID. Also see man setresuid,
> where you could, I think, use saved_uid=0 if you do not
> like to use real_uid=0 effective_uid=non-0.

But CAP_SETUID would let me change to any uid, would it not? I would like my 
process to have no possibility to change to any uid, except some predefined 
set, so that in case of a security hole only those uids could be compromised.
