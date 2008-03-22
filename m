Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYCVSiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYCVSiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbYCVSh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:37:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33505 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbYCVSh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:37:57 -0400
Date: Sat, 22 Mar 2008 18:37:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Margit Schubert-While <margitsw@t-online.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gcc change and kernel build
Message-ID: <20080322183756.GD10722@ZenIV.linux.org.uk>
References: <5.1.0.14.2.20080322183805.02769f00@popmail.t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5.1.0.14.2.20080322183805.02769f00@popmail.t-online.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 06:40:03PM +0100, Margit Schubert-While wrote:
> Is this -
> http://marc.info/?l=gcc-bugs&m=120620193114127&w=2
> going to affect kernel builds?

Not unless somebody had decided to use nested functions in the kernel.
I'd ran into only one such, er, person of questionable habits and the
code in question had been long rewritten in C, IIRC.  Somebody might
have done that again, but it's not hard to check...
