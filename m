Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbXDCGN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbXDCGN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 02:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXDCGN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 02:13:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:14220 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbXDCGN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 02:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lXa04bVp+etNsJwb9PTeR6p2uhrMZoeTUWEQVLfldwBQr8tojdBzdltmWMhBOkAWvDB7B3DW48q5gdR1apdGcrz4I331ggyC+uB/hskCI2DlbOKLc9VE7j2RWm35OU86pFDY842Qh8vv4/S7n6GcvwvcgZ2xBnabg8b87Ec0L9A=
Subject: Re: MTRR Problem with 2.6.18-4
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Marco <marco4ever@libero.it>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <461138B2.6040806@libero.it>
References: <JFVCLH$F3BAE0357982714B025306FB8CF4A0C1@libero.it>
	 <461138B2.6040806@libero.it>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 14:13:11 +0800
Message-Id: <1175580791.7267.32.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 19:09 +0200, Marco wrote:
> Marco ha scritto:
> >   
> Any idea? :'(

Not sure why your /proc/mtrr output is like that, but if you want vesafb
to use mtrr, use:

video=vesafb:mtrr:3,ywrap... instead

(See Documentation/fb/vesafb.txt)

Tony


