Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbXKWTyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbXKWTyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 14:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbXKWTyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 14:54:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:13012 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181AbXKWTyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 14:54:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aNYAvD1oiBobzZgd9vgzFG3JeZYI+OUPb8SaqCE+WEnNyFtQXGGhj5N2GJ9hGItl7DCppL3epTJcGoxYwhshI24UZFPmhDsXyeRO/F8YOcYTA97tSeUG7B+LMP6HILK6/2vpUuWaDU44/uNjH/IlNTkP67ww15v5t78pmRJyMXo=
Message-ID: <118833cc0711231154i588cf7c1gb99e050999af8632@mail.gmail.com>
Date: Fri, 23 Nov 2007 14:54:39 -0500
From: "Morten Welinder" <mwelinder@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Inotify fails to send IN_ATTRIB events
In-Reply-To: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This looks bad, though:

include/linux/fsnotify.h:121: warning: passing argument 2 of
'audit_inode_child' from incompatible pointer type

Missing "->d_inode"?

M.
