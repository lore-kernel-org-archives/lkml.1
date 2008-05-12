Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYELWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYELWU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYELWUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:20:19 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:18501 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbYELWUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:20:18 -0400
Message-ID: <fa686aa40805121520y979ee37ga83221b74b35afe1@mail.gmail.com>
Date: Mon, 12 May 2008 16:20:17 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC] spi: Change modalias from a pointer to a character array
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net
In-Reply-To: <20080512151805.4c2763b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080509173146.2932.16141.stgit@trillian.secretlab.ca>
	 <20080512151805.4c2763b9.akpm@linux-foundation.org>
X-Google-Sender-Auth: cf5b5bd5787f35cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 4:18 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 09 May 2008 11:32:28 -0600
>  Grant Likely <grant.likely@secretlab.ca> wrote:
>
>  > From: Grant Likely <grant.likely@secretlab.ca>
>  >
>  > Currently, 'modalias' in the spi_device structure is a 'const char *'.
>  > The spi_new_device() function fills in the modalias value from a passed
>  > in spi_board_info data block.  Since it is a pointer copy, the new
>  > spi_device remains dependent on the spi_board_info structure after the
>  > new spi_device is registered (no other fields in spi_device directly
>  > depend on the spi_board_info structure; all of the other data is copied).
>  >
<snip>
>
>  I'm not really able to work out if this is a needed-in-2.6.26 thing.  I
>  assumed "not".

That's correct.  I'm also not even 100% sure that this is the best
approach.  I'm waiting/hoping for feedback from David.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
