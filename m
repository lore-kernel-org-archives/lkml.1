Return-Path: <linux-kernel-owner+w=401wt.eu-S1031602AbXEAJG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031602AbXEAJG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031603AbXEAJG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:06:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58106 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031602AbXEAJG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:06:58 -0400
Date: Tue, 1 May 2007 10:06:57 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Steve French <smfrench@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: SMB2 file system - should it be a distinct module
Message-ID: <20070501090657.GA17949@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Steve French <smfrench@gmail.com>, linux-kernel@vger.kernel.org,
	linux-cifs-client@lists.samba.org
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 05:52:43PM -0500, Steve French wrote:
> Any idea which would be preferred (smb2 support as part of cifs, or as
> a distinct smb2.ko module)?

Separate module please.  If we grow enough common code as some point
we can move it into a smb_common.ko helper library, but given your
above description I doubt that would useful.

