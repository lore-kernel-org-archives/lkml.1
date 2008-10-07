Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYJGQfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYJGQfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYJGQfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:35:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51662 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753554AbYJGQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:35:21 -0400
Date: Tue, 7 Oct 2008 17:35:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Holden <aciddeath@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: BKL still required for what functions?
Message-ID: <20081007173515.1c161dce@lxorguk.ukuu.org.uk>
In-Reply-To: <F99FEC4F-DEDD-4E55-93B4-A0761F30E1A2@gmail.com>
References: <F99FEC4F-DEDD-4E55-93B4-A0761F30E1A2@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008 22:24:12 -0600
Richard Holden <aciddeath@gmail.com> wrote:

> I'm doing some driver cleanup on the ixj telephony driver, mostly copy/ 
> paste and common code refactoring. I'm also looking at trying to get  
> rid of the BKL from the 2 places its used, so I was wondering if we  
> have a list of kernel calls that still require the BKL to be held, and  
> if we don't have a list would it be worthwhile to put one into  
> Documentation, I'd be willing to maintain the list as we removed the  
> BKL from the last core kernel places.

Its never so simple - a lot of the functions it depends what data you are
using or passing to them whether they are BKL safe.

Which bits use the BKL and what do you need to know is safe ?
