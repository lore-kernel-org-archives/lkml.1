Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYANQKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYANQKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYANQKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:10:33 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56566 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbYANQKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:10:33 -0500
Date: Mon, 14 Jan 2008 11:10:32 -0500
To: xerces8 <xerces8@butn.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: isofs maintainer and write support
Message-ID: <20080114161032.GN2310@csclub.uwaterloo.ca>
References: <WorldClient-F200801131428.AA28580079@butn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <WorldClient-F200801131428.AA28580079@butn.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 02:28:58PM +0100, xerces8 wrote:
> I write here as the MAINTAINERS file has no entry about the isofs.
> 
> The question is : Is there any plan/way/idea to have read/write support
> for isofs ?
> 
> I know of user space tools that can perform any operation (like
> create/read/write/rename/delete file/directory) but that is nowhere
> as convenient as a real filesystem.
> 
> Use case: Editing a iso9660 filesystem on a DVD+RW. With a r/w isofs most
> changes would take a few seconds, while without, the entire 4.5 gigabytes
> must be copied to HD, edited and then remastered back to the DVD medium.
> (Why I don't use another FS ? Because I use the DVD to store music for
> my car cd/dvd player and it understands only iso9660.)
> (neither does it know vorbis. Or aac+ :-( )

I find it hard to believe any device that can read a DVD doesn't support
UDF.  That would be a very dumb design choice.

UDF was designed for read/write use.  iso9660 was very much designed for
read only.  It is much more complex to update an iso9660 filesystem
after it is created.  It just wasn't meant for it.

--
Len Sorensen
