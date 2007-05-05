Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbXEEQ4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbXEEQ4P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933576AbXEEQ4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:56:15 -0400
Received: from ms-smtp-01.southeast.rr.com ([24.25.9.100]:40448 "EHLO
	ms-smtp-01.southeast.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933331AbXEEQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:56:14 -0400
Date: Sat, 5 May 2007 08:03:03 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Shirish S Pargaonkar <shirishp@us.ibm.com>
Cc: smfltc@linux.vnet.ibm.com, hch@infradead.org,
       linux-cifs-client-bounces+shirishp=us.ibm.com@lists.samba.org,
       Jeff Layton <jlayton@redhat.com>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: [PATCH] CIFS: make sec=none force an
	anonymous mount
Message-ID: <20070505120258.GC5054@salusa.poochiereds.net>
References: <463B624B.2060802@us.ibm.com> <OFEFD715DD.89A7A57F-ON872572D2.003A0BCE-862572D2.003AC6CA@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFEFD715DD.89A7A57F-ON872572D2.003A0BCE-862572D2.003AC6CA@us.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 05:41:35AM -0500, Shirish S Pargaonkar wrote:
> 
> When a session setup request is sent as an anonymous user (NUL user),
> should/could there be
> password associated with that?
> Right now, sec=none option, will prompt you for a password.

We should probably turn off password prompting if sec=none is specified.

> And when we add code to retry session setup as anonymous user if the first
> session setup request
> fails, should that retry request be sent with the password or without
> password?
> 
> When smbfs sends requests as an anonymous user, it does not send a password
> along with it.
> 

I'd say we'd want to avoid sending along the password in any situation where
it wasn't really needed.

-- Jeff

