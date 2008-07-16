Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbYGPQbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbYGPQbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbYGPQbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:31:23 -0400
Received: from outbound-mail-101.bluehost.com ([69.89.22.11]:38196 "HELO
	outbound-mail-101.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756183AbYGPQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:31:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=fi+ZG7y3QLOVE6BrJO3NuK59c3i+MkAZ0w0XaIv6GcBbiKsYQMKZ3YxM1zU6+65EYFBXJsAnOTKprNxocivdW/ciwVrJ4DYEFFKxMSKWzcKniNTKJKa0Bf1KCIPFRBWK;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH 5/5] Ath5k: suspend/resume fixes
Date: Wed, 16 Jul 2008 09:31:11 -0700
User-Agent: KMail/1.9.9
Cc: "Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com> <1216136661-10930-4-git-send-email-jirislaby@gmail.com> <40f31dec0807160915g8a5b083p9f21fae729839445@mail.gmail.com>
In-Reply-To: <40f31dec0807160915g8a5b083p9f21fae729839445@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807160931.11473.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2008 9:15 am Nick Kossifidis wrote:
> It's ok for now, but have in mind that on my upcoming patch series i'm
> disabling msi (commented out) since it results no interrupts on pci-e
> cards (seems there is a bug in kernel's msi implementation).

Hm, would be good to get details here.  MSI is being used by other drivers 
successfully...

Jesse
