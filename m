Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbZKNEUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbZKNEUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 23:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbZKNEUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 23:20:45 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38124 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757338AbZKNEUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 23:20:44 -0500
X-Sasl-enc: MiNoA3tc91axTLYSZ8f1OHAWTwu5BHg7clm+gfQxTHoG 1258172449
Date: Sat, 14 Nov 2009 02:20:47 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] [PATCH v4 12/12] tree-wide: convert open
 calls to remove spaces to skip_spaces() lib function
Message-ID: <20091114042047.GF18847@khazad-dum.debian.net>
References: <cover.1257602781.git.andre.goddard@gmail.com>
 <7d5883637aa976b54e944998f635d47a41618a75.1257602781.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d5883637aa976b54e944998f635d47a41618a75.1257602781.git.andre.goddard@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Nov 2009, André Goddard Rosa wrote:
> Also, while at it, if we see (*str && isspace(*str)), we can be sure to
> remove the first condition (*str) as the second one (isspace(*str)) also
> evaluates to 0 whenever *str == 0, making it redundant. In other words,
> "a char equals zero is never a space".

You didn't document in isspace() that it must return false for NUL.  Please
do that before you remove any such checks.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
