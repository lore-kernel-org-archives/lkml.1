Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965653Ab0BZRnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:43:24 -0500
Received: from toccata.ens-lyon.org ([140.77.166.68]:36943 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965546Ab0BZRnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:43:21 -0500
Date: Fri, 26 Feb 2010 18:43:18 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Buggy variable-length array code...or compiler?
Message-ID: <20100226174318.GC7478@const.homenet.telecomitalia.it>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	=?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <1267139849.3079.68.camel@iscandar.digidescorp.com> <20100226014623.11d8d79f@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100226014623.11d8d79f@werewolf.home>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón, le Fri 26 Feb 2010 01:46:23 +0100, a écrit :
> int main()
> {
>     int c = 2;
>     while (1)
>     {
>         int a[c];
>         int b[c];

c is not variable here.

Samuel
