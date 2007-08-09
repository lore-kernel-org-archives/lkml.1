Return-Path: <linux-kernel-owner+w=401wt.eu-S966450AbXHIPgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966450AbXHIPgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965388AbXHIPgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:36:14 -0400
Received: from mail.fieldses.org ([66.93.2.214]:49835 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935191AbXHIPgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:36:09 -0400
Date: Thu, 9 Aug 2007 11:35:56 -0400
To: miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/4] pass open file to ->setattr()
Message-ID: <20070809153556.GB25475@fieldses.org>
References: <20070809152744.519270818@szeredi.hu> <20070809152859.787064024@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809152859.787064024@szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 05:27:45PM +0200, miklos@szeredi.hu wrote:
> This is needed to be able to correctly implement open-unlink-fsetattr
> semantics in some filesystem such as sshfs, without having to resort
> to "silly-renaming".

How do you plan to do that?

--b.
