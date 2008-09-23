Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYIWSNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYIWSNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYIWSND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:13:03 -0400
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:40299 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750982AbYIWSNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:13:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Zas1kl/d1x988jefPdRCv0IU541HyJAdp5ubqN5+JunFjT/nEo2urP3KFiu+Ve9EEwrMUKXgzvb1UkFHfUQyq79Z7yRXEOgjqaFkFk/HLiliYEYw5JudWc88v7pq8Gm7;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jike Song <albcamus@gmail.com>
Subject: Re: [PATCH] PCI: utilize calculated results when detecting MSI features
Date: Tue, 23 Sep 2008 11:12:57 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1220974923-5863-1-git-send-email-albcamus@gmail.com> <1220974923-5863-2-git-send-email-albcamus@gmail.com>
In-Reply-To: <1220974923-5863-2-git-send-email-albcamus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809231112.57613.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 9, 2008 8:42 am Jike Song wrote:
> in function msi_capability_init, we can make use of the calculated
> results instead of calling is_mask_bit_support and is_64bit_address
> twice, in spite of the fact that they are macros.
>
> Signed-off-by: Jike Song <albcamus@gmail.com>

Applied to linux-next.  Thanks.

Jesse
