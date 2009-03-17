Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZCQTJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZCQTJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZCQTJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:09:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57274 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZCQTJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:09:26 -0400
Date: Tue, 17 Mar 2009 15:09:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>,
       Gerd Hoffmann <kraxel@redhat.com>,
       Constantine Sapuntzakis <csapuntz@gmail.com>,
       Miklos Szeredi <miklos@szeredi.hu>, nikanth@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Block - Honour barrier requests in loop driver
Message-ID: <20090317190905.GA28816@infradead.org>
References: <200903171417.16760.knikanth@suse.de> <20090317091926.GA26016@infradead.org> <200903171739.50658.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903171739.50658.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 05:39:49PM +0530, Nikanth Karthikesan wrote:
> +			if (!file->f_op || !file->f_op->fsync) {
> +				ret = -EOPNOTSUPP;
> +				goto out;
> +			}

file->f_op is never zero, so you can remove the checks for that.
Otherwise looks good.

