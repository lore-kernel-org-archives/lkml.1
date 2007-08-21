Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbXHUTzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbXHUTzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbXHUTzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:55:43 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:35475 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750811AbXHUTzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:55:42 -0400
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: "Hex Star" <hexstar@gmail.com>
Subject: Re: Trouble booting with new 2.6.22.3 kernel
Date: Tue, 21 Aug 2007 22:56:59 +0300
User-Agent: KMail/1.9.7
References: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com> <5dc6fd9e0708211226k3f931579x6f8b3ab275f93c35@mail.gmail.com> <5dc6fd9e0708211227k22f9e214vd8132913214716b3@mail.gmail.com>
In-Reply-To: <5dc6fd9e0708211227k22f9e214vd8132913214716b3@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708212256.59281.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2007 22:27:25 you wrote:
> On 8/21/07, Hex Star <hexstar@gmail.com> wrote:
> > Ah so the IDE/SATA driver should not be a module (if it is a module
> > it'll cause this issue)?
>
> One more thing, are there any other critical kernel components that
> won't work as a module and thus prevent boot?

Well also the filesystem module for the root fs ( / ) should not be a module 
as you won't be able mount root at startup hence causing a panic.

Regards,
ismail

-- 
Perfect is the enemy of good
