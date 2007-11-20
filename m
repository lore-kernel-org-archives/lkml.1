Return-Path: <linux-kernel-owner+w=401wt.eu-S1763195AbXKTCSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763195AbXKTCSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXKTCO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:14:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:2971 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762267AbXKTCOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:message-id:to:subject:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=jaZdStEAPhSKlh54jI27UVJI72t9rTN0gh/IkgaTET606/v/wI4S+VwqMpIhbhq+fzyTYPGNkoRX9L7EfHfQdrFVL+wrOmYfnvaJWe1yMqW9d7MreQP+D0Dmt38PwCivzTlcVdnVQlJxWmBI8JONktKiOiwtINQdQQeRktnVRv8=
Date: Tue, 20 Nov 2007 10:13:42 +0800 (CST)
Message-Id: <20071120.101342.85695496.goodmenzy@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Is there any word about this bug in gcc ?
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: zhengyi <goodmenkernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any relevance to the kernel ?

I found the folowing code here:
http://linux.solidot.org/article.pl?sid=07/11/19/0512218&from=rss

-------------------------------------------------------------------
int main( void )
{
  int i=2;
  if( -10*abs (i-1) == 10*abs(i-1) )
    printf ("OMG,-10==10 in linux!\n");
  else
    printf ("nothing special here\n") ;

  return 0 ;
}
