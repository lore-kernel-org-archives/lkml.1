Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbZA3Aip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbZA3Aip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758661AbZA3Ai3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:38:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333AbZA3Ai2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:38:28 -0500
Message-ID: <49824BFA.3000203@zytor.com>
Date: Thu, 29 Jan 2009 16:38:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: RFC: running out of x86 boot loader IDs
References: <49823683.6060201@zytor.com> <18818.19160.962399.20413@harpo.it.uu.se>
In-Reply-To: <18818.19160.962399.20413@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Why do we need a boot loader id at all? The purpose of a boot loader,
> whatever it may be, is to load the kernel according to certain protocols.
> Once that's done, why would the kernel care who/what loaded it?

A couple of reasons...

a) Bugs happen.  Sometimes bugs are latent, and we later find ourselves
    in an unenviable position of not being able to work around a problem
    unless we know that we were loaded by <loader X> with <problem Y>.
b) Distro installers or other distro components sometimes find this
    useful.

	-hpa
