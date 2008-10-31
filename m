Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbYJaNPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbYJaNPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYJaNPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:15:33 -0400
Received: from lazybastard.de ([212.112.238.170]:57596 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYJaNPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:15:33 -0400
Date: Fri, 31 Oct 2008 14:15:24 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081031131524.GF18182@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org> <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org> <1225458436.5546.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1225458436.5546.2.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 October 2008 14:07:16 +0100, Johannes Berg wrote:
> 
> OTOH, there is no need to put the SSID in if I put a small list into
> each node, effectively using the tree instead of the hash table and then
> disambiguating the unlikely case of multiple SSID in a list.

Exactly.  In sunny wheather btrees can be a good implementation for hash
tables.  They can grow and shrink as needed, without taking the latency
hit for rehashing every single item.  Until lock contention or pingpong
shows otherwise. :(

Most likely the answer to bad whether is RCU.  Patches are welcome.

Jörn

-- 
They laughed at Galileo.  They laughed at Copernicus.  They laughed at
Columbus. But remember, they also laughed at Bozo the Clown.
-- unknown
